//
//  MapViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "MapViewController.h"
#import "OSDatabase.h"
#import "Establecimientos.h"
#import "RestaurantDetailViewController.h"

@interface MapViewController ()

@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, strong) NSArray* tempLocations;
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

    self.tempLocations = [self establecimientosArray];
    self.array = [NSMutableArray array];
    for (Establecimientos* location in self.tempLocations) {
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D cord;
        cord.latitude = [location.gps_lat floatValue];
        cord.longitude = [location.gps_lng floatValue];
        annotation.coordinate = cord;
        annotation.title = location.nombre;
        annotation.subtitle = location.direccion;
        
        [self.array addObject:annotation];
    }
    
    [self.mapView addAnnotations:self.array];
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView* view = [[MKAnnotationView alloc]
                              initWithAnnotation:annotation
                                 reuseIdentifier:@"restaurantID"];
    view.image = [UIImage imageNamed:@"copa2"];
    view.centerOffset = CGPointMake(0, -15);
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:
                                      UIButtonTypeDetailDisclosure];
    return view;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	// Si el zoom es poco, eliminamos las anotaciones y ponemos una vista gris translucida
	// para que el usuario haga zoom
	MKCoordinateRegion region = mapView.region;
	if(region.span.latitudeDelta > 0.02) {
		[self.mapView removeAnnotations:self.array];
		[self showHelpView];
	} else {
        [mapView addAnnotations:self.array];
        [self hideHelpView];
	}
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    RestaurantDetailViewController* viewController = [self.storyboard
                                                      instantiateViewControllerWithIdentifier:@"RestaurantDetail"];
    NSUInteger index = [self.array indexOfObject:view.annotation];
    viewController.object = self.tempLocations[index];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Help View

- (void)showHelpView
{
    if (self.loadingView == nil)
    {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 160.0, 300.0, 60.0)];
        self.loadingView.opaque = NO;
        self.loadingView.backgroundColor = [UIColor darkGrayColor];
        self.loadingView.alpha = 0.8;
		self.loadingView.layer.cornerRadius = 15.0;
		
		UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30.0,0,240.0,60.0)];
		label.textAlignment = UITextAlignmentCenter;
		label.numberOfLines = 2;
		label.font = [UIFont boldSystemFontOfSize:17];
		label.text = @"Para ver la información, aumente el nivel de zoom.";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[self.loadingView addSubview:label];
    }
	
    [self.view addSubview:self.loadingView];
}

- (void)hideHelpView
{
    [self.loadingView removeFromSuperview];
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

- (NSArray *)establecimientosArray {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Establecimientos"];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

@end
