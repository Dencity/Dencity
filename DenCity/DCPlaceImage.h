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


- (void)getImageWithBlock:(placeImageCompletion)block;

+ (DCPlaceImage*)placeImageWithImage:(UIImage*)image;

@end
