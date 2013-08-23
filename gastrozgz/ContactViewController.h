//
//  ContactViewController.h
//  gastrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *data;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *formButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
- (IBAction)formButtonPressed:(id)sender;
- (IBAction)callButtonPressed:(id)sender;
- (IBAction)facbookPressed:(id)sender;
- (IBAction)instagramPressed:(id)sender;
- (IBAction)twitterPressed:(id)sender;
@end
