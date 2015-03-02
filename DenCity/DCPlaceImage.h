//
//  DCPlaceImage.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/25/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface DCPlaceImage : PFObject <PFSubclassing>

typedef void(^placeImageCompletion)(UIImage*, NSError*);

@property (retain) PFFile *imageFile;
@property (retain) PFUser *takenBy;
@property (retain) NSDate *timeStamp;

- (void)getImageWithBlock:(placeImageCompletion)block;

+(NSString*)parseClassName;
+ (DCPlaceImage*)placeImageWithImage:(UIImage*)image;
- (NSString*)stringFromTimeStamp;

@end
