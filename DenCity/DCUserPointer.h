//
//  DCUserPointer.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/14/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>

@interface DCUserPointer : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *userId;

+ (DCUserPointer*)pointerForUser:(PFUser*)user;

+ (NSString*)parseClassName;

@end
