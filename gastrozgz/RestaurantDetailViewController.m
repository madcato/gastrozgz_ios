//
//  RestaurantDetailViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/27/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "AppDelegate.h"
#import "Establecimientos.h"

@interface RestaurantDetailViewController ()

@property (nonatomic, strong) NSMutableArray* photos;

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

- (NSString*)prepareDescription:(NSString*)text {
    NSString* html = [NSString stringWithFormat:@"<HTML>"
                      "<BODY style='color:white;background-color:black;font-family:Helvetica;'>"
                      "%@</BODY></HTML>",text];
    return html;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.titleLabel.text = self.object.nombre;
    [self.imageLabel setImageWithURL:[NSURL URLWithString:self.object.url_foto]
                    placeholderImage:[UIImage imageNamed:@"copa_placeholder"]];
    [self.descriptionText loadHTMLString:
                            [self prepareDescription:self.object.descripcion]
                                 baseURL:nil];
    [[self.descriptionText scrollView] setIndicatorStyle:
                                        UIScrollViewIndicatorStyleWhite];
    self.address.text = self.object.direccion;
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D cord;
    cord.latitude = [self.object.gps_lat floatValue];
    cord.longitude = [self.object.gps_lng floatValue];
    annotation.coordinate = cord;
    annotation.title = self.object.nombre;
    annotation.subtitle = self.object.direccion;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
    navController.navigationBarHidden = YES;
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
    [self showGallery:nil];
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

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark Image gallery

- (void)showGallery:(NSString*)resourceName {
    // Create array of `MWPhoto` objects
    self.photos = [NSMutableArray array];
    NSArray* files = @[@"http://livedesignonline.com/site-files/livedesignonline.com/files/archive/blog.livedesignonline.com/briefingroom/wp-content/uploads/2010/05/restaurant-t-buenos-aires.jpg",@"http://cdn5.business-opportunities.biz/wp-content/uploads/2013/01/restaurant.jpg"];
    
    for (NSString* path in files) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:path]]];
    }
    
    // Create & present browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.wantsFullScreenLayout = YES; // Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    browser.displayActionButton = YES; // Show action button to save, copy or email photos (defaults to NO)
    [browser setInitialPageIndex:0];
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
