//
//  DCTableViewCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/7/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface DCTableViewCell : UITableViewCell

@property (nonatomic, strong) PFImageView *placeImageView;

@property (nonatomic, strong) UIImageView *typeImageView;

@property (nonatomic, strong) MarqueeLabel *nameLabel;

@property (nonatomic, strong) UILabel *populationLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *typeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
