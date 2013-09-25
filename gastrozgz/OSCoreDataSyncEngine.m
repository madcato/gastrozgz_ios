//
//  OSCoreDataSyncEngine.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import "OSCoreDataSyncEngine.h"
#import "OSDatabase.h"
#import "NSManagedObject+JSON.h"
#import "CatEst.h"
#import "Categorias.h"
#import "Establecimientos.h"

NSString * const kOSCoreDataSyncEngineInitialCompleteKey = @"OSCoreDataSyncEngineInitialSyncCompleted";
NSString * const kOSCoreDataSyncEngineSyncCompletedNotificationName = @"OSCoreDataSyncEngineSyncCompleted";

@interface OSCoreDataSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) id<HTTPAPIClient> registeredAPIClient;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OSCoreDataSyncEngine

+ (OSCoreDataSyncEngine *)sharedEngine {
    static OSCoreDataSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[OSCoreDataSyncEngine alloc] init];
    });
    return sharedEngine;
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }

    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            NSLog(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
            abort();
        }
    } else {
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
        abort();
    }
}

- (void)registerHTTPAPIClient:(id<HTTPAPIClient>)apiClient {
    if (self.registeredAPIClient) {
        NSLog(@"Already registered HTTPAPIClient");
        abort();
    }
    self.registeredAPIClient = apiClient;
}

- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kOSCoreDataSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kOSCoreDataSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        [[OSDatabase backgroundDatabase] save];
        [[OSDatabase defaultDatabase] save];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kOSCoreDataSyncEngineSyncCompletedNotificationName
         object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    //
    // Create a new fetch request for the specified entity
    //
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    //
    // Set the sort descriptors on the request to sort by modified_at in descending order
    //
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"modified_at" ascending:NO]]];
    //
    // You are only interested in 1 result so limit the request to 1
    //
    [request setFetchLimit:1];
    [[[OSDatabase backgroundDatabase] managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[OSDatabase backgroundDatabase] managedObjectContext]  executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"modified_at"];
        }
    }];

    return date;
}

- (void)newManagedObjectWithClassName:(NSString *)className
                            forRecord:(NSDictionary *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[OSDatabase backgroundDatabase] managedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:OSObjectSynced] forKey:@"syncStatus"];
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
    if ([key isEqualToString:@"created_at"] || [key isEqualToString:@"modified_at"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else {
        id formattedValue = [self formatValue:value forKey:key forObject:managedObject];
        [managedObject setValue:formattedValue forKey:key];
    }
}

- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(OSObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];

    return results;
}

- (NSArray *)catEstArray {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CatEst"];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (NSArray *)managedObjectsToDeleteForClass:(NSString *)className {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"estado = %@", @"B"];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (NSManagedObject *)managedObjectForClass:(NSString *)className withObjectId:(NSString*) objectid{
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectid = %@", objectid];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    if ((results == nil) || ([results count] == 0)) {
        return nil;
    }
    return results[0];
}

- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectid IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectid IN %@)", idArray];
    }

    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:@"objectid" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];

    return results;
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    if (!toDelete) {
        NSMutableArray *operations = [NSMutableArray array];
        for (NSString *className in self.registeredClassesToSync) {
            NSDate *mostRecentUpdatedDate = nil;
            if (useUpdatedAtDate) {
                mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
            }
            NSMutableURLRequest *request = [self.registeredAPIClient
                                            GETRequestForAllRecordsOfClass:className
                                            updatedAfterDate:mostRecentUpdatedDate];
            AFHTTPRequestOperation *operation = [self.registeredAPIClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray* array;
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError* error;
                    array = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:0
                                                              error:&error];
                } else {
                    array = responseObject;
                }
                if ([array isKindOfClass:[NSArray class]]) {
                    //NSLog(@"Response for %@: %@", className, array);
                    // Need to write JSON files to disk
                    [self writeJSONResponse:array toDiskForClassWithName:className];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Request for class %@ failed with error: %@", className, error);
            }];
            
            [operations addObject:operation];
        }
        
        [self.registeredAPIClient enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
            
        } completionBlock:^(NSArray *operations) {
            NSLog(@"All operations completed");
            // Need to process JSON records into Core Data
            
            [self processJSONDataRecordsIntoCoreData];
        }];
        
    } else {
        [self processJSONDataRecordsForDeletion];
    }
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) { // import all downloaded data to Core Data for initial sync
            //
            // If this is the initial sync then the logic is pretty simple, you will fetch the JSON data from disk
            // for the class of the current iteration and create new NSManagedObjects for each record
            //
            NSArray *JSONArray = [self JSONArrayForClassWithName:className];
            NSArray *records = JSONArray;
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            //
            // Otherwise you need to do some more logic to determine if the record is new or has been updated.
            // First get the downloaded records from the JSON response, verify there is at least one object in
            // the data, and then fetch all records stored in Core Data whose objectId matches those from the JSON response.
            //
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectid"];
            if ([downloadedRecords lastObject]) {
                //
                // Now you have a set of objects from the remote service and all of the matching objects
                // (based on objectId) from your Core Data store. Iterate over all of the downloaded records
                // from the remote service.
                //
                int currentIndex = 0;
                //
                // If the number of records in your Core Data store is less than the currentIndex, you know that
                // you have a potential match between the downloaded records and stored records because you sorted
                // both lists by objectId, this means that an update has come in from the remote service
                //
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;

                    // Make sure we don't access an index that is out of bounds as we are iterating over both collections together
                  
                    storedManagedObject = [self managedObjectForClass:className withObjectId:[record valueForKey:@"objectid"]];
                    
                    if (storedManagedObject != nil) {
                        //
                        // Do a quick spot check to validate the objectIds in fact do match, if they do update the stored
                        // object with the values received from the remote service
                        //
                        [self updateManagedObject:storedManagedObject withRecord:record];
                    } else {
                        //
                        // Otherwise you have a new object coming in from your remote service so create a new
                        // NSManagedObject to represent this remote object locally
                        //
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        //
        // Once all NSManagedObjects are created in your context you can save the context to persist the objects
        // to your persistent store. In this case though you used an NSManagedObjectContext who has a parent context
        // so all changes will be pushed to the parent context
        //
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save context for class %@", className);
            }
        }];

        //
        // You are now done with the downloaded JSON responses so you can delete them to clean up after yourself,
        // then call your -executeSyncCompletedOperations to save off your master context and set the
        // syncInProgress flag to NO
        //
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    [self downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
}

- (void)processJSONDataRecordsForDeletion {
    
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        if ([className isEqualToString:@"CatEst"] == NO) {
            //
            // Remove all objects with estado property set to 'B'
            //
            NSArray *storedRecords = [self
                                      managedObjectsToDeleteForClass:className];

            //
            // Schedule the NSManagedObject for deletion and save the context
            //
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in storedRecords) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved) {
                    NSLog(@"Unable to save context after deleting records for class %@ because %@", className, error);
                }
            }];
        } else {
            // Create relations between Categories and Restaurants
            NSArray* catEstArrays = [self catEstArray];
            for (CatEst* catEst in catEstArrays) {
                Establecimientos* establecimiento = (Establecimientos*)
                [self managedObjectForClass:@"Establecimientos"
                               withObjectId:catEst.codigo_establecimiento];
                Categorias* categoria = (Categorias*)
                [self managedObjectForClass:@"Categorias"
                               withObjectId:catEst.codigo_categoria];
                if ((categoria != nil) && (establecimiento != nil)) {
                    [establecimiento addCategoriasObject:categoria];
                    [categoria addEstablecimientosObject:establecimiento];
                }
            }
            // Delete CatEst table
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in catEstArrays) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved) {
                    NSLog(@"Unable to save context after deleting records for class %@ because %@", className, error);
                }
            }];
        }
    }
    //
    // Execute the sync completion operations as this is now the final step of the sync process
    //
    [self executeSyncCompletedOperations];
}

- (void)startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        });
    }
}

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

- (NSArray *)JSONArrayForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSArray arrayWithContentsOfURL:fileURL];
}

- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key {
    NSArray *JSONArray = [self JSONArrayForClassWithName:className];
    NSArray *records = JSONArray;
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                 [NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}

- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        NSLog(@"Unable to delete JSON Records at %@, reason: %@", url, error);
    }
}

#pragma mark - Date formatter 

- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    return dateString;
}

#pragma mark - File Management

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }

    return url;
}

- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSArray *)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // remove NSNulls and try again...
        NSArray *records = response;
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }

        if (![nullFreeRecords writeToFile:[fileURL path] atomically:YES]) {
            NSLog(@"Failed all attempts to save response to disk: %@", response);
        }
    }
}

-(id)formatValue:(id)value
          forKey:(NSString*)key
       forObject:(NSManagedObject*) object {
    NSDictionary* properties = [[object entity] propertiesByName];
    NSAttributeDescription* description = properties[key];
    if([description isKindOfClass:[NSAttributeDescription class]]) {
        NSAttributeType type = description.attributeType;
        switch (type) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
                return value;
                break;
            case NSDoubleAttributeType:
                return value;
                break;
            case NSFloatAttributeType:
                return value;
                break;
            case NSBooleanAttributeType:
                //NSNumber;

                return value;
                break;
            case NSDecimalAttributeType:
                //NSDecimalNumber;
                return value;
                break;
            case NSStringAttributeType:
                //NSString;
                return value;
                break;
            case NSDateAttributeType:
                //NSDate;
                return [[OSCoreDataSyncEngine sharedEngine] dateUsingStringFromAPI:value];
                break;
            case NSBinaryDataAttributeType:
                //NSData;
                if ([value length] == 0) {
                    return [NSData data];
                }
                NSURL *url = [NSURL URLWithString:value];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                return dataResponse;
                break;

        }
    }
    
    return value;
}

+ (void)deleteObject:(NSManagedObject*)object inContext:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        // 1
        if ([[object valueForKey:@"objectid"] isEqualToString:@""] || [object valueForKey:@"objectid"] == nil) {
            [context deleteObject:object];
        } else {
            [object setValue:[NSNumber numberWithInt:OSObjectDeleted] forKey:@"syncStatus"];
        }
        // FIXME: No funciona el borrar objetos.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [[OSDatabase defaultDatabase] save];
        [[OSCoreDataSyncEngine sharedEngine] startSync];
    }];
}
@end
