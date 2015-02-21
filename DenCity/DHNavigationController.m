//
//  DHNavigationController.m
//  DenCity
//
//  Created by Dylan Humphrey on 10/11/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "DHNavigationController.h"

@implementation DHNavigationController

- (void)viewDidLoad
{
    __weak DHNavigationController *weakSelf = self;

        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
}

// Hijack the push method to disable the gesture

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    self.interactivePopGestureRecognizer.enabled = YES;
}

@end
