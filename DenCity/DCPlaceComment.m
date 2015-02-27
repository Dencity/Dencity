//
//  DCPlaceComment.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/2/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceComment.h"
#import <Parse/PFObject+Subclass.h>

CGFloat const kPlaceCommentMaxWordCount = 100;

@implementation DCPlaceComment

@dynamic message, sentBy, timeStamp;

+ (void)load{
    [self registerSubclass];
}

+ (NSString*)parseClassName{
    return @"DCPlaceComment";
}

+(DCPlaceComment*)commentForCurrentUser{
    DCPlaceComment *comment = [DCPlaceComment object];
    comment.sentBy = [PFUser currentUser];
    return comment;
}

- (void)setMessage:(NSString *)message{
    NSAssert((message.length > kPlaceCommentMaxWordCount), @"Message can only be 100 characters or less");
    self.message = message;
}

- (NSString*)stringFromTimeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:self.timeStamp];
}

@end
