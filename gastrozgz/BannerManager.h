//
//  BannerManager.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerManager : NSObject

+ (BannerManager *)sharedManager;
- (void)downloadData;

@end
