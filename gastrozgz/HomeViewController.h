//
//  HomeViewController.h
//  gatrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
