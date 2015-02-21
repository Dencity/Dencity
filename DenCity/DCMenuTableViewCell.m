//
//  DCMenuTableViewCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/6/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCMenuTableViewCell.h"
#import <pop/POP.h>

#define width(x) ([UIScreen mainScreen].bounds.size.width - 280) - x

@implementation DCMenuTableViewCell

@synthesize normalImage, selectedImage;

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self normalSetup];
    }
    return self;
}

- (void)normalSetup{
    
    CGFloat mutation = 5;
    
    CGFloat viewWidth = width(0);
    
    /*Setting up the views*/
    menuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth/2-15, viewWidth/2-15, 30, 30)];
    menuImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:menuImageView];
    
    originalImageFrame = menuImageView.frame;
    toImageFrame = CGRectMake(originalImageFrame.origin.x-mutation, originalImageFrame.origin.y-mutation, originalImageFrame.size.width+mutation*2, originalImageFrame.size.height+mutation*2);
    
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, viewWidth-.5, viewWidth, .5)];
    separator.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:separator];
    
}

#pragma mark - Selection

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        menuImageView.image = selectedImage;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:toImageFrame];
        anim.springBounciness = 12;
        anim.springSpeed = 6;
        [menuImageView pop_addAnimation:anim forKey:@"grow"];
        [self setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
    }
    else{
        menuImageView.image = normalImage;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:originalImageFrame];
        anim.springBounciness = 12;
        anim.springSpeed = 6;
        [menuImageView pop_addAnimation:anim forKey:@"shrink"];
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        menuImageView.image = selectedImage;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:toImageFrame];
        anim.springBounciness = 12;
        anim.springSpeed = 6;
        [menuImageView pop_addAnimation:anim forKey:@"grow"];
        [self setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
    }
    else{
        menuImageView.image = normalImage;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:originalImageFrame];
        anim.springBounciness = 12;
        anim.springSpeed = 6;
        [menuImageView pop_addAnimation:anim forKey:@"shrink"];
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

@end
