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
#import "ServerURL.h"
#import "AppDelegate.h"

@interface RestaurantDetailViewController () {
    AFJSONRequestOperation* operation;
    NSArray* downloadedImageList;
    BOOL shareSheet;
    NSMutableArray* urlArray;
}

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
    [self.moreDataButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [self downloadImageList];
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
    [self setMoreDataButton:nil];
    [super viewDidUnload];
}

- (IBAction)actionPressed:(id)sender {
    [self showShareSheet];
}

- (IBAction)viewMorePressed:(id)sender {
    [self showGallery:nil];
}

- (IBAction)moreDataPressed:(id)sender {
    [self showInfoSheet];
}

- (void)showShareSheet {
    shareSheet = YES;
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Compartir" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Compartir por Twitter", @"Compartir por Facebook", nil];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController* navController = (UINavigationController*)appDelegate.window.rootViewController;
    UITabBarController* tabController = (UITabBarController*)navController.topViewController;
    [actionSheet showFromTabBar:tabController.tabBar];
}


- (void)showInfoSheet {
    shareSheet = NO;
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Información" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    urlArray = [NSMutableArray array];
    
    if ([self canOpenURL:[self.object web]]) {
        [actionSheet addButtonWithTitle:@"Abrir web"];
        [urlArray addObject:[self.object web]];
    }

    if ([self canOpenURL:[self.object url_twitter]]) {
        [actionSheet addButtonWithTitle:@"Ver twitter"];
        [urlArray addObject:[self.object url_twitter]];
    }

    if ([self canOpenURL:[self.object url_facebook]]) {
        [actionSheet addButtonWithTitle:@"Ver Facebook"];
        [urlArray addObject:[self.object url_facebook]];
    }
    
    NSString* phone = [NSString stringWithFormat:@"tel:%@",[self.object telefono]];
    [actionSheet addButtonWithTitle:[self.object telefono]];
    [urlArray addObject:phone];

    [actionSheet addButtonWithTitle:@"Cerrar"];
    [urlArray addObject:@""];
    

    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController* navController = (UINavigationController*)appDelegate.window.rootViewController;
    UITabBarController* tabController = (UITabBarController*)navController.topViewController;
    [actionSheet showFromTabBar:tabController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (shareSheet == YES) {
        NSString* message = [NSString stringWithFormat:@"Descubre %@ en http://www.planogastronomicozaragoza.com/%@/establecimiento/%@",
                             [self.object nombre],
                             [self.object objectid],
                             [[self.object nombre] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        switch (buttonIndex) {
            case 0:{
                [self sendTweet:message];
                break;
            }
            case 1:
                [self sendFacebookPost:message];
                break;
            default:
                break;
        }
    } else {
        [self openURL:urlArray[buttonIndex]];
    }
}

- (void)openURL:(NSString*)urlString {
    NSString* formated = [self formatUrl:urlString];
    NSURL* url = [NSURL URLWithString:formated];
    if ([[UIApplication sharedApplication] canOpenURL:url] == YES)
        [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)canOpenURL:(NSString*)urlString {
    NSString* formated = [self formatUrl:urlString];
    NSURL* url = [NSURL URLWithString:formated];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (NSString*)formatUrl:(NSString*)urlString {
    if (([urlString length] > 4) && ([[[urlString substringToIndex:4] lowercaseString] isEqualToString:@"tel:"] == YES)) {
        return urlString;
    }

    if (([urlString length] > 4) && ([[[urlString substringToIndex:4] lowercaseString] isEqualToString:@"http"] == NO)) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    return urlString;
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
    for (NSDictionary* object in downloadedImageList) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:object[@"url_imagen"]]]];
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

#pragma mark - Image list download

- (void)activateViewMoreButton {
    [self.viewMoreButton setHidden:NO];
}

- (void)downloadImageList {
    [self.viewMoreButton setHidden:YES];
    [self performSelectorInBackground:@selector(downloadImageListBack)
                           withObject:nil];
}

- (void)downloadImageListBack {
    NSString* objectid = [self.object objectid];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                                                          [ServerURL imageListURL:objectid]]];
    operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//         [{
//             "created_at":"String content",
//             "estado":"String content",
//             "modified_at":"String content",
//             "objectid":"String content",
//             "url_imagen":"String content"
//         }]
         downloadedImageList = JSON;
         if ([downloadedImageList count] > 0) {
             [self performSelectorOnMainThread:@selector(activateViewMoreButton)
                                    withObject:nil
                                 waitUntilDone:NO];
         }
     }
                                                    failure:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         NSLog(@"Error downloading image list data: %@", [error localizedDescription]);
     }];
    
    [operation start];
}

#pragma mark - Share

-(void)sendTweet:(NSString*)message {
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:message];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                break;
            default:
                break;
        }
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
    
}

- (void)sendFacebookPost:(NSString*)message {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            } else
            {
                NSLog(@"Done");
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler = myBlock;
        
        [controller setInitialText:message];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        NSLog(@"UnAvailable");
    }
    
}

@end
