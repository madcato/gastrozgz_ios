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
	self.titleLabel.text = self.object[@"title"];
    [self.imageLabel setImageWithURL:[NSURL URLWithString:self.object[@"imageUrl"]]
                    placeholderImage:[UIImage imageNamed:@"copa_placeholder"]];
    self.descriptionText.text = self.object[@"description"];
    self.address.text = self.object[@"address"];
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D cord;
    cord.latitude = [self.object[@"latitude"]floatValue];
    cord.longitude = [self.object[@"longitude"]floatValue];
    annotation.coordinate = cord;
    annotation.title = self.object[@"title"];
    annotation.subtitle = self.object[@"address"];
    [self.locationMap addAnnotation:annotation];
    [self.locationMap setCenterCoordinate:cord];
    MKCoordinateRegion region = self.locationMap.region;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.locationMap setRegion:region];
    [self.locationMap setShowsUserLocation:YES];
    
    UIImage* image = [UIImage imageNamed:@"purple_button"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.viewMoreButton setBackgroundImage:image forState:UIControlStateNormal];
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
    [self setAddress:nil];
    [super viewDidUnload];
}
- (IBAction)actionPressed:(id)sender {
}

- (IBAction)viewMorePressed:(id)sender {
}

#pragma mark Map View delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView* view = [[MKAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:@"restaurantID"];
    view.image = [UIImage imageNamed:@"copa"];
    view.centerOffset = CGPointMake(0, -15);
    view.canShowCallout = YES;
    return view;
}

@end
