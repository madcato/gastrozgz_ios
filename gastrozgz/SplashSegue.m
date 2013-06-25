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
                    completion:NULL];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]
                                               delegate];
    appDelegate.window.rootViewController = self.destinationViewController;
}

@end
