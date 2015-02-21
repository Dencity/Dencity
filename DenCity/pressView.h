//
//  pressView.h
//  DenCity
//
//  Created by Dylan Humphrey on 6/27/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pressView;

@protocol pressViewDelegate <NSObject>

- (void)pressViewButtonWasPressed:(pressView*)pv;
- (void)pressViewWillExpand:(pressView*)pv;
- (void)pressViewWillShrink:(pressView*)pv;

@end

@interface pressView : UIView{
    @private
    
    int extended;
    
    UIImageView *imgView;
    
    UIView *lineView;
    UIView *tapView;
    
    CGFloat originalWidth;
    
}

//The image that is set for the view on the left
@property (nonatomic, strong) UIImage *image;

//The title for the button
@property (nonatomic, strong) UILabel *titleLabel;

//The delegate
@property (nonatomic, weak) id<pressViewDelegate> delegate;

- (void)setImage:(UIImage *)image;


@end
