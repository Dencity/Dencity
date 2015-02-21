
//
//  DCUserPointer.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/14/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCUserPointer.h"
#import <Parse/PFObject+Subclass.h>

@implementation DCUserPointer

@dynamic userId;

+ (NSString*)parseClassName{
    return @"DCUserPointer";
}

+ (DCUserPointer*)pointerForUser:(PFUser *)user{
    DCUserPointer *pointer = [DCUserPointer object];
    pointer.userId = user.objectId;
    return pointer;
}

@end
