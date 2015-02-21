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
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue - .1 alpha:.9f];
        }
    }
    else{
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue alpha:.9f];
        }
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize - 2];
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue - .1 alpha:.9f];
        }
    }
    else{
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        if (self.whiteValue != 100) {
            self.backgroundColor = [UIColor colorWithWhite:self.whiteValue alpha:.9f];
        }
    }
}

@end