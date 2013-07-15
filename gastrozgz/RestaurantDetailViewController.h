//
//  RestaurantDetailViewController.h
//  gastrozgz
//
//  Created by Daniel Vela on 6/27/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailViewController : UIViewController<MKMapViewDelegate,
MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet MKMapView *locationMap;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) NSDictionary *object;

- (IBAction)actionPressed:(id)sender;
- (IBAction)viewMorePressed:(id)sender;
@end
