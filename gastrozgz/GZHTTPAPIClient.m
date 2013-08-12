//
//  GZHTTPAPIClient.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import "GZHTTPAPIClient.h"
#import "ServerURL.h"
#import "AppDelegate.h"

@implementation GZHTTPAPIClient

+ (GZHTTPAPIClient *)sharedClient {
    static GZHTTPAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[GZHTTPAPIClient alloc] initWithBaseURL:
                        [NSURL URLWithString:[ServerURL baseURL]]];
    });

    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
//        [self setDefaultHeader:@"X-Parse-Application-Id" value:kOSAPIApplicationId];
//        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kOSAPIKey];
    }

    return self;
}

+ (NSString*)formatClassName:(NSString*)className {
    NSString* className2 = @"";
    if([className isEqualToString:@"Banner"]) {
        className2 = [ServerURL bannersURL:[AppDelegate preferredLanguage]];
    }
    if([className isEqualToString:@"Categorias"]) {
        className2 = [ServerURL categoriasURL:[AppDelegate preferredLanguage]];
    }
    if([className isEqualToString:@"Establecimientos"]) {
        className2 = [ServerURL establecimientosURL:[AppDelegate preferredLanguage]];
    }
    if([className isEqualToString:@"CatEst"]) {
        className2 = [ServerURL catEstURL];
    }
    return className2;
}
- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;

    NSString* className2 = [GZHTTPAPIClient formatClassName:className];
    request = [self requestWithMethod:@"GET" path:className2 parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

        NSString *jsonString = [dateFormatter stringFromDate:updatedDate];
        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"modified_at"];
    }

    request = [self GETRequestForClass:className parameters:paramters];
    return request;
}

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;

    NSString* className2 = [GZHTTPAPIClient formatClassName:className];
    request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@.json", className2] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {

    NSString* className2 = [GZHTTPAPIClient formatClassName:className];
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"%@/%@.json", className2, objectId] parameters:nil];
    return request;
}

@end
