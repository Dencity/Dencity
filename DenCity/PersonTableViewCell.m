//
//  PersonTableViewCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 11/24/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "PersonTableViewCell.h"

@interface PersonTableViewCell (){
    CGFloat wid;
}

@end

static CGFloat height = 50;

@implementation PersonTableViewCell

@synthesize profPic, nameLabel, type;

- (id)initWithType:(PersonTableViewCellType)_type reuseIdentifier:(NSString *)identifier width:(CGFloat)w{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.type = _type;
        wid = w;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    switch (type) {
        case PersonTableViewCellTypeAnonymous:
            [self setUpForAnonymous];
            break;
        case PersonTableViewCellTypePerson:
            [self setUpNormal];
            break;
        default:
            break;
    }
}

- (void)setUpForAnonymous{
    self.userInteractionEnabled = NO;
    
    profPic = [[PFImageView alloc]initWithFrame:CGRectMake(5, 5, height - 10, height - 10)];
    profPic.layer.borderWidth = 0;
    profPic.layer.cornerRadius = 3;
    profPic.clipsToBounds = YES;
    profPic.backgroundColor = [UIColor clearColor];
    profPic.image = [UIImage imageNamed:@"menu_Profile_White"];
    [self.contentView addSubview:profPic];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + profPic.frame.size.width + 7, 10, wid - (5 + profPic.frame.size.width + 7) - 40, height - 20)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nameLabel];
}

- (void)setUpNormal{
    profPic = [[PFImageView alloc]initWithFrame:CGRectMake(5, 5, height - 10, height - 10)];
    profPic.layer.cornerRadius = 3;
    profPic.clipsToBounds = YES;
    profPic.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:profPic];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + profPic.frame.size.width + 7, 10, wid - (5 + profPic.frame.size.width + 7) - 40, height - 20)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nameLabel];
}

@end
