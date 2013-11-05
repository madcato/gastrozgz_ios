//
//  CategoryCell.h
//  gastrozgz
//
//  Created by Daniel Vela on 10/6/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UIButton* leftButton;
@property (nonatomic, strong) IBOutlet UIButton* rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftText;
@property (weak, nonatomic) IBOutlet UILabel *rightText;

@end
