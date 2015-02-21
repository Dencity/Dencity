//
//  DCDrawerController.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/8/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCDrawerController.h"
#import "MMDrawerController+Subclass.h"

@class MMDrawerCenterContainerView;

@implementation DCDrawerController

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture{
    [super panGestureCallback:panGesture];
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    UIView *statusBar;
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        statusBar = [object valueForKey:key];
    }
}

- (void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL))completion{
    [super openDrawerSide:drawerSide animated:animated completion:completion];
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    UIView *statusBar;
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        statusBar = [object valueForKey:key];
    }
    statusBar.transform = CGAffineTransformMakeTranslation(self.centerViewController.view.frame.origin.x, self.centerViewController.view.frame.origin.y);
}

- (void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion{
    [super closeDrawerAnimated:animated completion:completion];
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    UIView *statusBar;
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        statusBar = [object valueForKey:key];
    }
    statusBar.transform = CGAffineTransformMakeTranslation(self.centerViewController.view.frame.origin.x, self.centerViewController.view.frame.origin.y);
    NSLog(@"called");
}


@end
