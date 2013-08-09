//
//  BannerManager.m
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "BannerManager.h"
#import "ServerURL.h"
#import "AppDelegate.h"

@interface BannerManager () {
    AFJSONRequestOperation* operation;
}

@end
@implementation BannerManager

+ (BannerManager *)sharedManager {
    static BannerManager *sharedBanner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBanner = [[BannerManager alloc] init];
    });
    return sharedBanner;
}

- (void)downloadData {
    NSString *language = [AppDelegate preferredLanguage];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                                            [ServerURL bannersURL:language]]];
    operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         // Sample JSON
//         {
//             "created_at" = "Jul  6 2013 10:04AM";
//             estado = D;
//             "modified_at" = "Jul  6 2013 10:04AM";
//             objectid = 15;
//             "url_imagen" = "http://www.planogastronomicozaragoza.com/images/banners/splash.jpg";
//             "url_link" = "#";
//         }
         
         
    }
                                                    failure:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         NSLog(@"Error downloading banner data: %@", [error localizedDescription]);
     }];
    
    [operation start];
}

@end
