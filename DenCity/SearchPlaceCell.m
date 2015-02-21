//
//  SearchPlaceCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 11/24/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "SearchPlaceCell.h"

@interface SearchPlaceCell (){
    CGFloat width;
    CGFloat height;
}

@end

@implementation SearchPlaceCell

@synthesize placeImage, nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        width = [UIScreen mainScreen].bounds.size.width;
        height = 60;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    placeImage = [[PFImageView alloc]initWithFrame:CGRectMake(10, 10, height - 20, height - 20)];
    placeImage.clipsToBounds = YES;
    placeImage.backgroundColor = [UIColor lightGrayColor];
    placeImage.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:placeImage];
        
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + placeImage.frame.size.width + 10, 10, width - (5 + placeImage.frame.size.width + 7) - 40, height - 20)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nameLabel];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
