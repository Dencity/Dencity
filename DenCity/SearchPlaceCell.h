//
//  SearchPlaceCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 11/24/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchPlaceCell : UITableViewCell

@property (nonatomic, strong) PFImageView *placeImage;

@property (nonatomic, strong) UILabel *nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
