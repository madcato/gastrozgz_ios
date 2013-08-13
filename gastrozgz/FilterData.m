//
//  FilterData.m
//  gastrozgz
//
//  Created by Daniel Vela on 8/13/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "FilterData.h"

@interface FilterData ()

@property (nonatomic, strong) NSArray* data;

@end

@implementation FilterData

// Shared Singleton
// Class method that returns a singleton instance
//
// Platform: All
// Language: Objective-C
// Completion Scope: Class Implementation

+ (FilterData *)sharedFilter {
    static FilterData *_sharedFilter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFilter = [[FilterData alloc] init];
        _sharedFilter.data = 
    });
    
    return _sharedFilter;
}

@end
