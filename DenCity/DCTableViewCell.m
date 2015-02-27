//
//  DCTableViewCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/7/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCTableViewCell.h"
#import <pop/POP.h>

@interface DCTableViewCell (){
    UIView *view;
    
    CGRect originalPlaceFrame;
    CGRect selectedPlaceFrame;
}

@end

@implementation DCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 200 - 10)];
        view.layer.cornerRadius = 4;
        view.layer.shadowRadius = 1.5f;
        view.layer.shadowOpacity = 1;
        view.layer.shadowOffset = CGSizeMake(0, 3);
        originalPlaceFrame = CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-40);
        selectedPlaceFrame = CGRectMake(-2.5, -2.5, view.frame.size.width + 5, view.frame.size.height-25);
        [self normalSetup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted){
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:selectedPlaceFrame];
        anim.springBounciness = 15;
        anim.springSpeed = 7;
        [self.placeImageView pop_addAnimation:anim forKey:@"grow"];
    }
    else{
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:originalPlaceFrame];
        anim.springBounciness = 15;
        anim.springSpeed = 7;
        [self.placeImageView pop_addAnimation:anim forKey:@"grow"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected){
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:selectedPlaceFrame];
        anim.springBounciness = 15;
        anim.springSpeed = 7;
        [self.placeImageView pop_addAnimation:anim forKey:@"grow"];
    }
    else{
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:originalPlaceFrame];
        anim.springBounciness = 15;
        anim.springSpeed = 7;
        [self.placeImageView pop_addAnimation:anim forKey:@"grow"];
    }
}

- (void)normalSetup{
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    
    self.placeImageView = [[UIImageView alloc]initWithFrame:originalPlaceFrame];
    self.placeImageView.layer.cornerRadius = 3;
    self.placeImageView.clipsToBounds = YES;
    self.placeImageView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, originalPlaceFrame.origin.y + originalPlaceFrame.size.height + 5, view.frame.size.width, .5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    self.nameLabel = [[MarqueeLabel alloc]initWithFrame:CGRectMake(10, _placeImageView.frame.size.height-35, _placeImageView.frame.size.width-20, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.populationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, view.frame.size.height - 25, 100, 20)];
    self.populationLabel.font = [UIFont systemFontOfSize:14];
    self.populationLabel.textColor = [UIColor blackColor];
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-60, view.frame.size.height-25, 60, 20)];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.textColor = [UIColor blackColor];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-25, view.frame.size.width, 20)];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor = [UIColor blackColor];
    
    [view addSubview:line];
    [view addSubview:self.placeImageView];
    [_placeImageView addSubview:self.nameLabel];
    [view addSubview:self.populationLabel];
    [view addSubview:self.distanceLabel];
    [view addSubview:_typeLabel];
    
    [self.contentView addSubview:view];
}

@end
