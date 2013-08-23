//
//  ContactViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString*)prepareDescription {
    NSString* html = [NSString stringWithFormat:@"<HTML>"
                      "<style>"
                      "p {margin:4;}"
                      "</style>"
                      "<BODY style='color:white;background-color:transparent;font-family:Helvetica;font-size:14px;'>"
                      "<p><b>ALMOZARA ARTISSTICA, S.L.</b></p>"
                      "<p>Avda. Puerta de Sancho 25 - 50003 Zaragoza</p>"
                      "<p>Departamento Comercial: 615 872 550</p>"
                      "<p>E-mail: info@planogastronomicozaragoza.com</p>"
                      "</BODY></HTML>"];
    return html;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.data loadHTMLString:
     [self prepareDescription] baseURL:nil];
    [[self.data scrollView] setScrollEnabled:NO];
    [[self.data scrollView] setUserInteractionEnabled:YES];
    
    UIImage* image = [UIImage imageNamed:@"purple_button"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.callButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.formButton setBackgroundImage:image forState:UIControlStateNormal];
    
    
    float lat = 41.663257;
    float lng = -0.90103177;
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D cord;
    cord.latitude = lat;
    cord.longitude = lng;
    annotation.coordinate = cord;
    annotation.title = @"euronovios.es";
    annotation.subtitle = @"Todo para tu boda";
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:cord];
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.mapView setRegion:region];
    [self.mapView setShowsUserLocation:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)viewDidUnload {
    [self setData:nil];
    [self setMapView:nil];
    [self setFormButton:nil];
    [self setCallButton:nil];
    [super viewDidUnload];
}
- (IBAction)formButtonPressed:(id)sender {
    [self openUrl:@"http://www.planogastronomicozaragoza.com/contacto.aspx"];
}

- (IBAction)callButtonPressed:(id)sender {
    [self openUrl:@"tel:615872550"];
}

- (IBAction)facbookPressed:(id)sender {
    [self openUrl:@"https://www.facebook.com/gastronomiazaragoza?fref=ts"];
}

- (IBAction)instagramPressed:(id)sender {
    [self openUrl:@"http://instagram.com/gastronomia_zgz"];
}

- (IBAction)twitterPressed:(id)sender {
    [self openUrl:@"https://twitter.com/gastronomicoZGZ"];
}

- (void)openUrl:(NSString*)urlString {
    NSURL* url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url] == YES) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
