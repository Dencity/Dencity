//
//  DCLocationManager.h
//  DenCity
//
//  Created by Dylan Humphrey on 12/31/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@protocol DCLocationManagerDelegate <NSObject>

- (void)DCLocationManagerDidFailWithError:(NSError*)error;
- (void)DCLocationManagerDidUpdateLocations:(NSArray*)locations;

@end

@interface DCLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<DCLocationManagerDelegate> delegate;

- (void)getUserLocationWithInterval:(int)interval;

@end
