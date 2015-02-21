//
//  pressView.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/27/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "pressView.h"

@implementation pressView

@synthesize image, titleLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 50)];
    if (self) {
        extended = 0;
        originalWidth = frame.size.width;
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        imgView.backgroundColor = [UIColor blackColor];
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed)];
        [imgView addGestureRecognizer:tap];
        
        [self addSubview:imgView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 320 - 50, 50)];
        titleLabel.alpha = 1;
        
        [self addSubview:titleLabel];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(44, 5, 1, 40)];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 1;
        
        [self addSubview:lineView];
        
        tapView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 260, 50)];
        tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainPressed)];
        [tapView addGestureRecognizer:tp];
        
        [self addSubview:tapView];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 1.5f;
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowOpacity = .75f;
        
    }
    return self;
}

- (void)buttonPressed{
    NSLog(@"pressed");
    if (extended == 1)
    {
        extended = 0;
        
        [self.delegate pressViewWillShrink:self];
    }
    else{
        extended = 1;
        
        [self.delegate pressViewWillExpand:self];
    }
    
}

- (void)mainPressed{
    [self.delegate pressViewButtonWasPressed:self];
}

- (void)setImage:(UIImage *)image{
    imgView.image = image;
}

@end
