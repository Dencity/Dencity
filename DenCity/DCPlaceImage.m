//
//  DCPlaceImage.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/25/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceImage.h"

@implementation DCPlaceImage

@dynamic imageFile, takenBy;

+ (NSString*)parseClassName{
    return @"DCPlaceImage";
}

- (void)getImageWithBlock:(placeImageCompletion)block{
    [self.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        block([UIImage imageWithData:data],error);
    }];
}

+ (DCPlaceImage*)placeImageWithImage:(UIImage *)image{
    DCPlaceImage *place = [DCPlaceImage object];
    NSData *data = UIImagePNGRepresentation(image);
    PFFile *file = [PFFile fileWithData:data];
    place.imageFile = file;
    return place;
}

@end
