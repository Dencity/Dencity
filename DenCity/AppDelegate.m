//
//  AppDelegate.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/26/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "DHNavigationController.h"
#import "MMDrawerVisualState.h"
#import "MainViewController.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"
#import <Parse/Parse.h>
#import "DCPlace.h"
#import "DCUtility.h"
#import "DCPlaceComment.h"
#import "DCPlaceImage.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize drawerController;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [DCPlace registerSubclass];
    [DCPlaceComment registerSubclass];
    [DCPlaceImage registerSubclass];
    
    [Parse setApplicationId:@"QpZKRJLiy7baIH1HjkMPGxSsEgFmAzc9tq9PwYTC"
                  clientKey:@"sAgh74Fq3a4adz0AaS0MUL1iLbNfK3lhLEXM0BrJ"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([PFUser currentUser]) {
        [self setUpForCurrentUser];
    }
    else{
        [self setUpForNewUser];
    }
    
    self.window.rootViewController = self.drawerController;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIImage *backButton = [[UIImage imageNamed:@"back1"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    [UINavigationBar appearance].backIndicatorImage = backButton;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButton;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([notification.alertBody containsString:@"arrived"]) {
        CWStatusBarNotification *note = [CWStatusBarNotification new];
        note.notificationLabelBackgroundColor = UIColorFromRGB(0x400040);
        note.notificationLabelTextColor = [UIColor whiteColor];
        note.notificationAnimationInStyle = CWNotificationAnimationStyleLeft;
        note.notificationAnimationOutStyle = CWNotificationAnimationStyleRight;
        [note displayNotificationWithMessage:[NSString stringWithFormat:@"You have arrived at %@", notification.userInfo[@"name"]] forDuration:3];
    }
    else{
        CWStatusBarNotification *note = [CWStatusBarNotification new];
        note.notificationLabelBackgroundColor = UIColorFromRGB(0x400040);
        note.notificationLabelTextColor = [UIColor whiteColor];
        note.notificationAnimationInStyle = CWNotificationAnimationStyleLeft;
        note.notificationAnimationOutStyle = CWNotificationAnimationStyleRight;
        [note displayNotificationWithMessage:[NSString stringWithFormat:@"You have left %@", notification.userInfo[@"name"]] forDuration:3];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    NSLog(@"Identifier %@", identifier);
    
    NSString * const lNotificationActionOne = @"lAction_One";
    NSString * const NotificationActionOne = @"Action_One";
    
    if ([identifier isEqualToString:NotificationActionOne]) {
        PFQuery *query = [DCPlace query];
        [query whereKey:@"name" equalTo:notification.userInfo[@"name"]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error){
                DCPlace *place = (DCPlace*)object;
                [place addPerson:[PFUser currentUser]];
                NSLog(@"successfully added person");
            }
        }];
    }
    if ([identifier isEqualToString:lNotificationActionOne]) {
        PFQuery *query = [DCPlace query];
        [query whereKey:@"name" equalTo:notification.userInfo[@"name"]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error){
                DCPlace *place = (DCPlace*)object;
                [place removePerson:[PFUser currentUser]];
                NSLog(@"successfully removed person");
            }
        }];
    }
    
    [[PFInstallation currentInstallation] setBadge:0];
    
    if (completionHandler) {
        completionHandler();
    }
    
}

- (void)setUpForCurrentUser{
    MainViewController *mv = [[MainViewController alloc]init];
    MenuViewController *meV = [[MenuViewController alloc]init];
    meV.delegate = (id<menuViewControllerDelegate>)mv;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mv];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barTintColor = [UIColor colorWithWhite:.15 alpha:1];
    nav.navigationBar.translucent = NO;
    
    CGRect navFrame = nav.navigationBar.frame;
    UIView *navBorder = [[UIView alloc]initWithFrame:CGRectMake(0, navFrame.size.height - 1, [UIScreen mainScreen].bounds.size.width, .5)];
    navBorder.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [nav.navigationBar addSubview:navBorder];
    
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:nav leftDrawerViewController:meV];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3]];
    self.drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width - 280;
    self.drawerController.maximumRightDrawerWidth = [UIScreen mainScreen].bounds.size.width;
}

- (void)setUpForNewUser{
    LoginViewController *lv = [[LoginViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lv];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
    nav.navigationBar.translucent = YES;
    nav.view.backgroundColor = [UIColor clearColor];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:nav leftDrawerViewController:nil];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3]];
    self.drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width - 280;
    self.drawerController.maximumRightDrawerWidth = [UIScreen mainScreen].bounds.size.width;
}

@end
