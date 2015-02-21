//
//  DCTransitionAnimator.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/10/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#define width(x) CGRectGetWidth([UIScreen mainScreen].bounds) - 280 + x

#import "DCTransitionAnimator.h"

@implementation DCTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        toViewController.view.frame = self.buttonFrame;
        
        CGRect endingFrame = [UIScreen mainScreen].bounds;
        
        fromViewController.view.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endingFrame;
        } completion:^(BOOL finished){
            [transitionContext completeTransition:YES];
        }];
    }
    else{
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endingFrame = self.buttonFrame;
        
        toViewController.view.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endingFrame;
        } completion:^(BOOL finshed){
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
        }];
    }
}

@end
