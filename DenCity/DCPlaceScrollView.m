//
//  DCPlaceScrollView.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/22/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceScrollView.h"

#define DEGREES_TO_RADIANS(x) ((x) / 180.0 * M_PI)

@implementation DCPlaceScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.pagingEnabled = YES;
    self.clipsToBounds = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    self.effect = DCPlaceScrollViewEffectNone;
}

- (void)setEffect:(DCPlaceScrollViewEffect)effect{
    self->_effect = effect;
    
    switch (effect){
        case DCPlaceScrollViewEffectTranslation:
            self.angleRatio = 0;
            
            self.rotationX = 0;
            self.rotationY = 0;
            self.rotationZ = 0;
            
            self.translateX = .25;
            self.translateY = .25;
            
            break;
        case DCPlaceScrollViewEffectDepth:
            self.angleRatio = .5;
            
            self.rotationX = -1;
            self.rotationY = 0;
            self.rotationZ = 0;
            
            self.translateX = .25;
            self.translateY = 0;
            
            break;
        case DCPlaceScrollViewEffectCarousel:
            self.angleRatio = 5;
            
            self.rotationX = -1;
            self.rotationY = 0;
            self.rotationZ = 0;
            
            self.translateX = .25;
            self.translateY = .25;
            
            break;
        case DCPlaceScrollViewEffectCards:
            self.angleRatio = .5;
            
            self.rotationX = -1;
            self.rotationY = -1;
            self.rotationZ = 0;
            
            self.translateX = .25;
            self.translateY = .25;
            
            break;
        default:
            self.angleRatio = 0;
            
            self.rotationX = 0;
            self.rotationY = 0;
            self.rotationZ = 0;
            
            self.translateX = 0;
            self.translateY = 0;
            break;
    }
    [self setNeedsDisplay];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat contentOffsetX = self.contentOffset.x;
    
    for (UIView *view in self.subviews){
        CATransform3D t1 = view.layer.transform;
        view.layer.transform = CATransform3DIdentity;
        
        CGFloat distanceFromCenterX = view.frame.origin.x - contentOffsetX;
        
        view.layer.transform = t1;
        
        distanceFromCenterX = distanceFromCenterX * 100 / CGRectGetWidth(self.frame);
        
        CGFloat angle = distanceFromCenterX * self.angleRatio;
        
        CGFloat offset = distanceFromCenterX;
        CGFloat translateX = (CGRectGetWidth(self.frame) * self.translateX) * offset/100;
        CGFloat translateY = (CGRectGetWidth(self.frame) * self.translateY) *abs(offset)/100;
        CATransform3D t = CATransform3DMakeTranslation(translateX, translateY, 0);
        
        view.layer.transform = CATransform3DRotate(t, DEGREES_TO_RADIANS(angle), self.rotationX, self.rotationY, self.rotationZ);
    }
}

- (NSUInteger)currentPage{
    CGFloat pageWidth = self.frame.size.width;
    float fractionalPage = self.contentOffset.x / pageWidth;
    return lround(fractionalPage);
}

- (void)loadNextPage:(BOOL)animated{
    [self loadPageAtIndex:self.currentPage + 1 animated:animated];
}

- (void)loadPreviousPage:(BOOL)animated{
    [self loadPageAtIndex:self.currentPage - 1 animated:animated];
}

- (void)loadPageAtIndex:(NSUInteger)index animated:(BOOL)animated{
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    
    [self scrollRectToVisible:frame animated:animated];
}

@end
