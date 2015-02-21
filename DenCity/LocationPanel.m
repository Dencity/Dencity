//
//  LocationPanel.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/11/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "LocationPanel.h"
#import <CoreLocation/CoreLocation.h>
#import "MYBlurIntroductionView.h"

@interface LocationPanel () <CLLocationManagerDelegate>{
    CLLocationManager *manager;
    CGRect theFrame;
}

@end

@implementation LocationPanel

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    self = [super initWithFrame:frame title:title description:description];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        manager.delegate = self;
        theFrame = frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView{
    self = [super initWithFrame:frame title:title description:description header:headerView];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        theFrame = frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image{
    self = [super initWithFrame:frame title:title description:description image:image];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        theFrame = frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView{
    self = [super initWithFrame:frame title:title description:description image:image header:headerView];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        theFrame = frame;
    }
    return self;
}

- (void)panelDidAppear{
    [self.parentIntroductionView setEnabled:NO];
    enableButton = [[DUIButton alloc]initWithFrame:CGRectMake(50, theFrame.size.height - 80, theFrame.size.width - 100 , 40) fontSize:20 whiteValue:100];
    enableButton.layer.borderColor = [UIColor whiteColor].CGColor;
    enableButton.layer.borderWidth = 1.0f;
    enableButton.layer.cornerRadius = 4.0f;
    [enableButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enableButton setTitle:@"Enable" forState:UIControlStateNormal];
    [enableButton addTarget:self action:@selector(enabled:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enableButton];
}

- (void)panelDidDisappear{
    [manager stopUpdatingLocation];
    manager = nil;
}

- (void)enabled:(id)sender{
    if (manager) {
        [manager requestAlwaysAuthorization];
        [manager startUpdatingLocation];
        enableButton.userInteractionEnabled = NO;
    }
}

#pragma mark - Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Uh Oh..." message:@"You have not permitted the application to use your location. Please go to Privacy > Location Services and enable them for Dencity" delegate:self cancelButtonTitle:@"Sorry :(" otherButtonTitles:nil];
        [alertView show];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HasAllowedLocation"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations) {
        [self.parentIntroductionView setEnabled:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasAllowedLocation"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
