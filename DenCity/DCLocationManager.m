//
//  DCLocationManager.m
//  DenCity
//
//  Created by Dylan Humphrey on 12/31/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "DCLocationManager.h"

int const kMaxBGTime = 170;
int const kTimeToGetLocations = .5;

@interface DCLocationManager (){
    UIBackgroundTaskIdentifier bgTask;
    CLLocationManager *locationManager;
    NSTimer *checkLocationTimer;
    int checkLocationInterval;
    NSTimer *waitForLocationUpdatesTimer;
}

@end

@implementation DCLocationManager

- (instancetype)init{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

- (void)getUserLocationWithInterval:(int)interval{
    checkLocationInterval = (interval > kMaxBGTime)? kMaxBGTime : interval;
    [locationManager startUpdatingLocation];
}

- (void)timerEvent:(NSTimer*)timer{
    [self stopCheckLocationTimer];
    [locationManager startUpdatingLocation];
    
    [self performSelector:@selector(stopBackgroundTask) withObject:nil afterDelay:1];
}

- (void)startCheckLocationTimer{
    [self stopCheckLocationTimer];
    checkLocationTimer = [NSTimer scheduledTimerWithTimeInterval:checkLocationInterval target:self selector:@selector(timerEvent:) userInfo:NULL repeats:NO];
}

- (void)stopCheckLocationTimer{
    if (checkLocationTimer) {
        [checkLocationTimer invalidate];
        checkLocationTimer = nil;
    }
}

- (void)startBackgroundTask{
    [self stopBackgroundTask];
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self timerEvent:checkLocationTimer];
    }];
}

- (void)stopBackgroundTask{
    if (bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)stopWaitForLocationUpdatesTimer{
    if (waitForLocationUpdatesTimer) {
        [waitForLocationUpdatesTimer invalidate];
        waitForLocationUpdatesTimer = nil;
    }
}

- (void)startWaitForLocationUpdatesTimer{
    [self stopWaitForLocationUpdatesTimer];
    waitForLocationUpdatesTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeToGetLocations target:self selector:@selector(waitForLocations:) userInfo:NULL repeats:NO];
}

- (void)waitForLocations:(NSTimer*)timer{
    [self stopWaitForLocationUpdatesTimer];
    
    if (([[UIApplication sharedApplication]applicationState] == UIApplicationStateBackground || [[UIApplication sharedApplication]applicationState] == UIApplicationStateInactive) && bgTask == UIBackgroundTaskInvalid){
        
        [self startBackgroundTask];
    }
    
    [self startCheckLocationTimer];
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (checkLocationTimer) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DCLocationManagerDidUpdateLocations:)]) {
        [self.delegate DCLocationManagerDidUpdateLocations:locations];
    }
    
    if (waitForLocationUpdatesTimer == nil) {
        [self startWaitForLocationUpdatesTimer];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DCLocationManagerDidFailWithError:)]) {
        [self.delegate DCLocationManagerDidFailWithError:error];
    }
}

#pragma mark - UIApplication Notifications

- (void)applicationDidEnterBackground:(NSNotification*)notification{
    if ([self isLocationServiceAvailable] == YES) {
        [self startBackgroundTask];
    }
}

- (void)applicationDidBecomeActive:(NSNotification*)notification{
    
}

#pragma mark - Helper Methods

- (BOOL)isLocationServiceAvailable{
    if ([CLLocationManager locationServicesEnabled]==NO || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}


@end
