//
//  MapViewController.m
//  gatrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MKUserTrackingBarButtonItem* button = [[MKUserTrackingBarButtonItem alloc]
                                           initWithMapView:self.mapView];
    self.navigationItem.rightBarButtonItem = button;
    [self pressUserTrackingButton];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"stations_bizi"
                                         withExtension:@"plist"];
    NSDictionary* tempDict = [NSDictionary dictionaryWithContentsOfURL:url];
    NSArray* tempLocations = [tempDict valueForKey:@"stations"];
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* location in tempLocations) {
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D cord;
        cord.latitude = [location[@"latitude"]floatValue];
        cord.longitude = [location[@"longitude"]floatValue];
        annotation.coordinate = cord;
        annotation.title = @"Hola";
        annotation.subtitle = @"Adios";
        
        [array addObject:annotation];
    }
    
    [self.mapView addAnnotations:array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)pressUserTrackingButton {
    UIBarButtonItem* item = self.navigationItem.rightBarButtonItem;
    [item performSelector:item.action];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark Map View delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation {
    MKAnnotationView* view = [[MKAnnotationView alloc]
                              initWithAnnotation:annotation
                                 reuseIdentifier:@"restaurantID"];
    view.image = [UIImage imageNamed:@"copa"];
    view.centerOffset = CGPointMake(0, -25);
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:
                                      UIButtonTypeDetailDisclosure];
    return view;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
}

@end
