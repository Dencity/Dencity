//
//  DCPlaceComment.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/2/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>

@interface DCPlaceComment : PFObject <PFSubclassing>

@property (retain) NSString *message;
@property (retain) NSDate *timeStamp;
@property (retain) PFUser *sentBy;

+ (NSString*)parseClassName;
+ (DCPlaceComment*)commentForCurrentUser;
- (NSString*)stringFromTimeStamp;

@end
