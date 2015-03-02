//
//  DUIButton.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "DUIButton.h"

@implementation DUIButton

- (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)size whiteValue:(CGFloat)value
{
    self = [super initWithFrame:frame];
    if (self) {
        if (value != 100) {
            self.backgroundColor = [UIColor colorWithWhite:value alpha:.9];
            self.whiteValue = value;
        }
        else{
            self.whiteValue = 100;
            self.backgroundColor = [UIColor clearColor];
        }
        self.fontSize = size;
        self.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:YES];
    if (highlighted) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize - 2];
        CGRect rect = self.imageView.frame;
        rect.origin.x -=5;
        rect.origin.y -=5;
        rect.size.width += 10;
        rect.size.height += 10;
        [UIView animateWithDuration:.3 animations:^{self.imageView.frame = rect;}];
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue - .1 alpha:.9f];
        }
    }
    else{
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        CGRect rect = self.imageView.frame;
        rect.origin.x +=5;
        rect.origin.y +=5;
        rect.size.width -= 10;
        rect.size.height -= 10;
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue alpha:.9f];
        }
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize - 2];
        CGRect rect = self.imageView.frame;
        rect.origin.x -=5;
        rect.origin.y -=5;
        rect.size.width += 10;
        rect.size.height += 10;
        [UIView animateWithDuration:.3 animations:^{self.imageView.frame = rect;}];
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue - .1 alpha:.9f];
        }
    }
    else{
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        CGRect rect = self.imageView.frame;
        rect.origin.x +=5;
        rect.origin.y +=5;
        rect.size.width -= 10;
        rect.size.height -= 10;
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue alpha:.9f];
        }
    }
}

@end
