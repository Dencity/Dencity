//
//  PlaceTableViewCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 8/18/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "WDActivityIndicator.h"

@interface PlaceTableViewCell ()

@end

@implementation PlaceTableViewCell

@synthesize placeImageView, nameLabelM, populationLabel, distanceLabel, mainView, topRightView;

- (id)initWithType:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        mainView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, width - 20, 100)];
        [self setupViews];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted){
        mainView.backgroundColor = [UIColor grayColor];
    }
    else{
        mainView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected{
    if (selected){
        mainView.backgroundColor = [UIColor grayColor];
    }
    else{
        mainView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setupViews{
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    
    originalFrame = mainView.frame;
    mainView.layer.cornerRadius = 3;
    mainView.backgroundColor = [UIColor whiteColor];
    
    topRightView = [[UIImageView alloc]initWithFrame:CGRectMake(mainView.frame.size.width - 40, 10, 30, 30)];
    
    placeImageView = [[PFImageView alloc]initWithFrame:CGRectMake(12.5, 12.5, mainView.frame.size.height - 25, mainView.frame.size.height - 25)];
    placeImageView.layer.borderColor = [UIColor blackColor].CGColor;
    placeImageView.layer.borderWidth = 1.0f;
    placeImageView.layer.cornerRadius = 4;
    placeImageView.clipsToBounds = YES;
    placeImageView.backgroundColor = [UIColor lightGrayColor];
    
    nameLabelM = [[MarqueeLabel alloc]initWithFrame:CGRectMake(placeImageView.frame.size.width + 10 + placeImageView.frame.origin.x, 23, 200 , 20)];
    nameLabelM.font = [UIFont systemFontOfSize:14];

    populationLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelM.frame.origin.x, nameLabelM.frame.origin.y + nameLabelM.frame.size.height, nameLabelM.frame.size.width, 20)];
    populationLabel.font = [UIFont systemFontOfSize:13];
    
    distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelM.frame.origin.x, populationLabel.frame.origin.y + populationLabel.frame.size.height, nameLabelM.frame.size.width, 20)];
    distanceLabel.font = [UIFont systemFontOfSize:13];
    
    [mainView addSubview:nameLabelM];
    [mainView addSubview:placeImageView];
    [mainView addSubview:populationLabel];
    [mainView addSubview:distanceLabel];
    [mainView addSubview:topRightView];
    
    [self.contentView addSubview:mainView];
}

@end
