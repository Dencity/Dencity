//
//  ServicePanel.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/11/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "ServicePanel.h"
#import <CoreLocation/CoreLocation.h>
#import "MYBlurIntroductionView.h"

@interface ServicePanel ()<CLLocationManagerDelegate>{
    CLLocationManager *manager;
    UILabel *label;
}

@end

@implementation ServicePanel

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    self = [super initWithFrame:frame title:title description:description];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        manager.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView{
    self = [super initWithFrame:frame title:title description:description header:headerView];
    if (self) {
        manager = [[CLLocationManager alloc]init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image{
    self = [super initWithFrame:frame title:title description:description image:image];
    if (self) {
        manager = [[CLLocationManager alloc]init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView{
    self = [super initWithFrame:frame title:title description:description image:image header:headerView];
    if (self) {
        manager = [[CLLocationManager alloc]init];
    }
    return self;
}

- (void)panelDidAppear{
    [self.parentIntroductionView setEnabled:NO];
    [manager startUpdatingLocation];
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, self.frame.size.width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"Swipe Right to Begin Using Decity";
    label.alpha = 0;
    [self addSubview:label];
}

- (void)panelDidDisappear{
    [manager stopUpdatingLocation];
    manager = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasAllowedLocation"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.parentIntroductionView setEnabled:YES];
        [UIView animateWithDuration:.3 animations:^{label.alpha = 1;}];
    }
}

@end
