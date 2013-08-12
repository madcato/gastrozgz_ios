//
//  CatEst.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/10/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CatEst : NSManagedObject

@property (nonatomic, retain) NSString * codigo_categoria;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * codigo_establecimiento;
@property (nonatomic, retain) NSDate * modified_at;
@property (nonatomic, retain) NSString * objectid;

@end
