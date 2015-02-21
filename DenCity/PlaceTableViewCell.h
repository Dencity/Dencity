//
//  PlaceTableViewCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 8/18/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MarqueeLabel.h"

@interface PlaceTableViewCell : UITableViewCell{
    @private
    CGRect originalFrame;
}

@property (nonatomic, strong) PFImageView *placeImageView;

@property (nonatomic, strong) UIImageView *topRightView;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) MarqueeLabel *nameLabelM;

@property (nonatomic, strong) UILabel *populationLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

- (id)initWithType:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;


@end
