//
//  Categorias.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/10/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Establecimientos;

@interface Categorias : NSManagedObject

@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * estado;
@property (nonatomic, retain) NSDate * modified_at;
@property (nonatomic, retain) NSString * objectid;
@property (nonatomic, retain) NSSet *establecimientos;
@end

@interface Categorias (CoreDataGeneratedAccessors)

- (void)addEstablecimientosObject:(Establecimientos *)value;
- (void)removeEstablecimientosObject:(Establecimientos *)value;
- (void)addEstablecimientos:(NSSet *)values;
- (void)removeEstablecimientos:(NSSet *)values;

@end
