
//
//  CircleButton.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/12/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

@synthesize selected, index, centerImageView;

- (id)initWithFrame:(CGRect)frame index:(NSInteger)i{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = i;
        selected = false;
        orignalFrame = frame;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
     centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, orignalFrame.size.width, orignalFrame.size.width)];
     [self addSubview:centerImageView];
}

- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        [UIView animateWithDuration:.2 animations:^{
            [centerImageView setFrame:CGRectMake(0 + 5, 0 + 5, orignalFrame.size.width - 5, orignalFrame.size.height - 5)];
        }];
    }
    else{
        [UIView animateWithDuration:.2 animations:^{
            [centerImageView setFrame:orignalFrame];
        }];
    }
}

- (void)setSelected:(BOOL)selected{
    
}

- (void)selectButton{
    selected = YES;
    [UIView animateWithDuration:.2 animations:^{
        [centerImageView setFrame:CGRectMake(orignalFrame.origin.x + 5, orignalFrame.origin.y + 5, orignalFrame.size.width - 5, orignalFrame.size.height - 5)];
    }];
}

- (void)unselectButton{
    selected = NO;
    [UIView animateWithDuration:.2 animations:^{
        [centerImageView setFrame:orignalFrame];
    }];
}

@end
