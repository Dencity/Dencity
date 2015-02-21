//
//  CircleButton.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/12/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleButton : UIButton{
    @private
    CGRect orignalFrame;
}

@property (nonatomic, strong) UIImage *centerImage;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic) BOOL selected;
@property (nonatomic) NSUInteger index;

- (id)initWithFrame:(CGRect)frame index:(NSInteger)index;

- (void)selectButton;
- (void)unselectButton;

@end
