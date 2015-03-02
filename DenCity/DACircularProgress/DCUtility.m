//
//  DCUtility.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/16/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCUtility.h"
#import <CoreImage/CoreImage.h>

@implementation DCUtility

+ (void)registerNotificationSetttingsForEntering{

    NSString * const NotificationCategoryIdentifier = @"CategoryEntering";
    NSString * const NotificationActionOne = @"Action_One";
    NSString * const NotificationActionTwo = @"Action_Two";
    
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
    [action1 setActivationMode:UIUserNotificationActivationModeBackground];
    [action1 setTitle:@"Cancel"];
    [action1 setIdentifier:NotificationActionOne];
    [action1 setDestructive:NO];
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc]init];
    [action2 setActivationMode:UIUserNotificationActivationModeBackground];
    [action2 setTitle:@"Enter"];
    [action2 setIdentifier:NotificationActionTwo];
    [action2 setDestructive:NO];
    
    UIMutableUserNotificationCategory *actionCategory = [[UIMutableUserNotificationCategory alloc]init];
    [actionCategory setIdentifier:NotificationCategoryIdentifier];
    [actionCategory setActions:@[action2,action1] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

+ (void)registerNotificationSetttingsForLeaving{

    NSString * const lNotificationCategoryIdentifier = @"CategoryLeaving";
    NSString * const lNotificationActionOne = @"lAction_One";
    NSString * const lNotificationActionTwo = @"lAction_Two";
    
    UIMutableUserNotificationAction *laction1 = [[UIMutableUserNotificationAction alloc]init];
    [laction1 setActivationMode:UIUserNotificationActivationModeBackground];
    [laction1 setTitle:@"Cancel"];
    [laction1 setIdentifier:lNotificationActionOne];
    [laction1 setDestructive:NO];
    
    UIMutableUserNotificationAction *laction2 = [[UIMutableUserNotificationAction alloc]init];
    [laction2 setActivationMode:UIUserNotificationActivationModeBackground];
    [laction2 setTitle:@"Leave"];
    [laction2 setIdentifier:lNotificationActionTwo];
    [laction2 setDestructive:NO];
    
    UIMutableUserNotificationCategory *lactionCategory = [[UIMutableUserNotificationCategory alloc]init];
    [lactionCategory setIdentifier:lNotificationCategoryIdentifier];
    [lactionCategory setActions:@[laction2,laction1] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *lcategories = [NSSet setWithObject:lactionCategory];
    UIUserNotificationType ltypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *lsettings = [UIUserNotificationSettings settingsForTypes:ltypes categories:lcategories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:lsettings];
}

+ (void)pushLocalNotificationWithMessage:(NSString *)message placeName:(NSString *)name{
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate date];
    notification.alertBody = message;
    notification.category = @"";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:name , @"name", nil];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)user:(PFUser *)user shouldEnterPlace:(DCPlace *)place{
    [place addPerson:user withCompletion:^(BOOL finished){}];
}

+ (void)user:(PFUser *)user shouldLeavePlace:(DCPlace *)place{
    [place removePerson:user withCompletion:^(BOOL finished){}];
}

+ (BOOL)containsIllegalCharacters:(NSString *)string{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end


@implementation UIImage (DCImageUtilities)

+ (UIImage*)imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0, 0, 1, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)inverseColor:(UIImage*)image{
    CIImage *core = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:core forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    return  [UIImage imageWithCIImage:result];
}

+ (UIImage*)changeImage:(UIImage*)img ToColor:(UIColor *)color{
    //begin a new image context to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    //get a reference to that context we just created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set the fill color
    [color setFill];
    
    //translate the graphics context from CG coords to UI coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    //set the blend moede to color burn and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    //set a mast that matches the shape of the image, then draw a colored rect
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    //grap the image fromt he context we just drew on
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end
