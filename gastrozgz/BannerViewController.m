//
//  BannerViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 7/4/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "BannerViewController.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

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
	// Do any additional setup after loading the view.
    [self.image setImageWithURL:[NSURL URLWithString:self.imageURL]];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [self.image addGestureRecognizer:gesture];
}

- (void)imageTapped {
    if ((self.clickURL != nil) && ([self.clickURL isEqualToString:@""]) == NO) {
        NSURL* url = [NSURL URLWithString:self.clickURL];
        if ([[UIApplication sharedApplication] canOpenURL:url] == YES)
            [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImage:nil];
    [super viewDidUnload];
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
