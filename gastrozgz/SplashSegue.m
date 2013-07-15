//
//  SplashSegue.m
//  gatrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "SplashSegue.h"
#import "AppDelegate.h"

@implementation SplashSegue

- (void)perform {
    UIView* fromView = [self.sourceViewController view];
    UIView* toView = [self.destinationViewController view];
    [UIView transitionFromView:fromView
                        toView:toView duration:2.0
                       options:UIViewAnimationOptionCurveEaseInOut |
                               UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]
                                                                  delegate];
                        UINavigationController* navController =
                        (UINavigationController*)appDelegate.window.rootViewController;
                        [navController pushViewController:self.destinationViewController animated:NO];
                    }];
    
}

@end
