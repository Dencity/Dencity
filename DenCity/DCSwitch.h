//
//  DCSwitch.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/26/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSwitch : UIControl

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *labelTextColorInsideSlider;
@property (nonatomic, strong) UIColor *labelTextColorOutsideSlider;
@property (nonatomic, strong) UIFont  *font;
@property (nonatomic) CGFloat         cornerRadius;
@property (nonatomic) CGFloat         sliderOffset;

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;
- (instancetype)initWithAttributedStringsArray:(NSArray *)strings;

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated;

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated; 


@end
