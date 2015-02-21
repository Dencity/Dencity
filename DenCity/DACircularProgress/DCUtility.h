//
//  DCUtility.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/16/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DCPlace.h"

@interface DCUtility : NSObject

/*These methods will change the buttons that the notification shows
 *Entering: Will be an enter and a cancel button
 *Leaving: Will be a leave and a cancel button
 */
+ (void)registerNotificationSetttingsForEntering;
+ (void)registerNotificationSetttingsForLeaving;

/*A quick method that will send a local notification*/
+ (void)pushLocalNotificationWithMessage:(NSString*)message placeName:(NSString*)name;

/*Shortcut methods to enter a user into a place or remove them from a place*/
+ (void)user:(PFUser*)user shouldEnterPlace:(DCPlace*)place;
+ (void)user:(PFUser*)user shouldLeavePlace:(DCPlace*)place;

@end

@interface UIImage (DCImageUtilities)

+ (UIImage*)imageWithColor:(UIColor*)color;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*)inverseColor:(UIImage*)image;
+ (UIImage*)changeImage:(UIImage*)img ToColor:(UIColor*)color;

@end
