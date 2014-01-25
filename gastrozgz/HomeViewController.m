//
//  HomeViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "HomeViewController.h"
#import "BannerViewController.h"
#import "AppDelegate.h"
#import "OSDatabase.h"

@interface HomeViewController () {
    NSArray* banners;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Ofertas", @"");
	// Do any additional setup after loading the view.
    banners = [[OSDatabase defaultDatabase] getResultsFrom:@"Banner"
                                                 sortArray:@[@"created_at"]
                                             withPredicate:nil
                                              andArguments:nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    if ([banners count] > 0) {
        BannerViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    }
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    
    [self setTabNames];
}

- (void)setTabNames {
    UITabBarController* tabController = (UITabBarController*)self.parentViewController.parentViewController;
    UITabBar* tabBar = tabController.tabBar;
    
    UITabBarItem* item = tabBar.items[0];
    [item setTitle:NSLocalizedString(@"Ofertas", @"")];
    item = tabBar.items[1];
    [item setTitle:NSLocalizedString(@"Mapa", @"")];
    item = tabBar.items[2];
    [item setTitle:NSLocalizedString(@"Establecimientos", @"")];
    item = tabBar.items[3];
    [item setTitle:NSLocalizedString(@"Contacto", @"")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BannerViewController *)viewControllerAtIndex:(NSUInteger)index {
    BannerViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerView"];
    childViewController.index = index;
    childViewController.imageURL = [banners[index] valueForKey:@"url_imagen"];
    childViewController.clickURL = [banners[index] valueForKey:@"url_link"];
    return childViewController;
}

#pragma mark - Page control data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(BannerViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(BannerViewController *)viewController index];
    
    
    index++;
    
    if (index == [banners count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [banners count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
