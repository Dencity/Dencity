//
//  DCPlaceScrollView.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/22/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCPlaceScrollViewEffect){
    DCPlaceScrollViewEffectNone,
    DCPlaceScrollViewEffectTranslation,
    DCPlaceScrollViewEffectDepth,
    DCPlaceScrollViewEffectCarousel,
    DCPlaceScrollViewEffectCards
};

@interface DCPlaceScrollView : UIScrollView

@property (nonatomic) DCPlaceScrollViewEffect effect;

@property (nonatomic) CGFloat angleRatio;

@property (nonatomic) CGFloat rotationX;
@property (nonatomic) CGFloat rotationY;
@property (nonatomic) CGFloat rotationZ;

@property (nonatomic) CGFloat translateX;
@property (nonatomic) CGFloat translateY;

- (NSUInteger)currentPage;

- (void)loadNextPage:(BOOL)animated;
- (void)loadPreviousPage:(BOOL)animated;
- (void)loadPageAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
