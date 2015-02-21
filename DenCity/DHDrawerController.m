//
//  DHDrawerController.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/6/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DHDrawerController.h"

@implementation DHDrawerController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidLoad];
}

- (void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL))completion{
    [super openDrawerSide:drawerSide animated:animated completion:completion];
    return;
    if (showing) {
        return;
    }
    statusView = [[UIScreen mainScreen]snapshotViewAfterScreenUpdates:NO];
    [self.centerViewController.view addSubview:statusView];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    showing = YES;
}

- (void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion{
    [super closeDrawerAnimated:animated completion:completion];
    return;
    if (showing) {
        [statusView removeFromSuperview];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        showing = NO;
    }
}

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture{
    [super panGestureCallback:panGesture];
    NSLog(@"%f",[panGesture translationInView:self.view].x);
    return;
    if (showing) {
        
    }
    else{
        statusView = [[UIScreen mainScreen]snapshotViewAfterScreenUpdates:NO];
        [self.centerViewController.view addSubview:statusView];
    }
}

- (void)tapGestureCallback:(UITapGestureRecognizer *)tapGesture{
    [super tapGestureCallback:tapGesture];
    return;
    [statusView removeFromSuperview];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    showing = NO;
}

- (void)currentStatusView{
    if (!statusView) {
        statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [statusView addSubview:[[UIScreen mainScreen]snapshotViewAfterScreenUpdates:NO]];
        statusView.clipsToBounds = YES;
    }
}

@end
