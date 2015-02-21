//
//  DCTransitionAnimator.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/10/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL presenting;
@property (nonatomic) CGRect buttonFrame;

@end
