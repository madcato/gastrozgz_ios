//
//  RestaurantCell.m
//  gastrozgz
//
//  Created by Daniel Vela on 7/14/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.accessoryView = [[UIImageView alloc] initWithImage:
                              [UIImage
                               imageNamed:@"cellaccessory"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
