//
//  DCMenuCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/4/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCMenuCell.h"
#import <pop/POP.h>

@implementation DCMenuCell

@synthesize centerView, centerLabel, selected;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    selected = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    
    centerView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 3.0f;
    centerView.layer.borderWidth = .75f;
    centerView.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:centerView];
    
    centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, centerView.frame.size.height/2 - 10, centerView.frame.size.width, 20)];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.textColor = [UIColor blackColor];
    centerLabel.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:centerLabel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    selected = YES;
    [self.delegate selectedDCMenuCell:self];
    [self toggleSelection];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (location.x > 0 && location.y > 0) {
        //success
        [self.delegate selectedDCMenuCell:self];
    }
    else{
        selected = NO;
        [self toggleSelection];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (location.x > 0 && location.y > 0){
    }
    else{
        selected = NO;
        [self toggleSelection];
    }
}

- (void)toggleSelection{
    if (selected) {
        centerView.backgroundColor = [UIColor blackColor];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        anim.toValue = [UIColor whiteColor];
        [centerLabel pop_addAnimation:anim forKey:@"white"];
    }
    else{
        centerView.backgroundColor = [UIColor whiteColor];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        anim.toValue = [UIColor blackColor];
        [centerLabel pop_addAnimation:anim forKey:@"black"];
    }
}

@end
