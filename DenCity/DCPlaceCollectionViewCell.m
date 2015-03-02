//
//  DCPlaceCollectionViewCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/28/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceCollectionViewCell.h"

@interface DCPlaceCollectionViewCell(){
    UIView *dimView;
}

@end

@implementation DCPlaceCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_imageView];
        
        dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        dimView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
        dimView.hidden = YES;
        [self addSubview:dimView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        dimView.hidden = NO;
    }
    else{
        dimView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        dimView.hidden = NO;
    }
    else{
        dimView.hidden = YES;
    }
}

@end
