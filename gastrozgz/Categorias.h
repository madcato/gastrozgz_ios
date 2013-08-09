//
//  Categorias.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Categorias : NSManagedObject

@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * estado;
@property (nonatomic, retain) NSDate * modified_at;
@property (nonatomic, retain) NSString * objectid;

@end
