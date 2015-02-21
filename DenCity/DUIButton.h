//
//  DUIButton.h
//  DenCity
//
//  Created by Dylan Humphrey on 6/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DUIButton : UIButton

@property (nonatomic) CGFloat fontSize;

@property (nonatomic) CGFloat whiteValue;

- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)size whiteValue:(CGFloat)value;

@end
