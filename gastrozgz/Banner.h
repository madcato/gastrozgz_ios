//
//  Banner.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Banner : NSManagedObject

@property (nonatomic, retain) NSString * objectid;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * modified_at;
@property (nonatomic, retain) NSString * url_link;
@property (nonatomic, retain) NSString * url_imagen;
@property (nonatomic, retain) NSString * estado;

@end
