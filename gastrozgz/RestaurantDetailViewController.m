//
//  RestaurantDetailViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/27/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "RestaurantDetailViewController.h"

@interface RestaurantDetailViewController ()

@end

@implementation RestaurantDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setImageLabel:nil];
    [self setViewMoreButton:nil];
    [self setDescriptionText:nil];
    [self setLocationMap:nil];
    [super viewDidUnload];
}
- (IBAction)actionPressed:(id)sender {
}

- (IBAction)viewMorePressed:(id)sender {
}
@end
