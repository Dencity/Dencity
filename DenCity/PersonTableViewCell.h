//
//  PersonTableViewCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 11/24/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef NS_OPTIONS(NSInteger, PersonTableViewCellType){
    PersonTableViewCellTypeNone = 0,
    PersonTableViewCellTypePerson = 1 << 1,
    PersonTableViewCellTypeAnonymous = 1 << 2,
};

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic, strong) PFImageView *profPic;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic) PersonTableViewCellType type;

- (id)initWithType:(PersonTableViewCellType)_type reuseIdentifier:(NSString*)identifier width:(CGFloat)w;

@end
