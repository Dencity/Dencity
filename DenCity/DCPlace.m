//
//  DCPlace.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/3/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlace.h"
#import <Parse/PFObject+Subclass.h>

@interface DCPlace ()

@end

@implementation DCPlace

@dynamic name, address, population, oldPopulation, storedPopulation, location, type, people, comments, images, placeId, placeImage;

+ (NSString*)parseClassName{
    return @"DCPlace";
}

- (BOOL)isEqualToPlace:(DCPlace *)place{
    if (!place) {
        return NO;
    }
    
    BOOL equalName = [self.name isEqualToString:place.name];
    BOOL equalAddress = [self.address isEqualToString:place.address];
    BOOL equalId = self.placeId == place.placeId;
    
    return equalAddress && equalId && equalName;
}

- (BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[DCPlace class]]) {
        return NO;
    }
    
    return [self isEqualToPlace:(DCPlace*)object];
}

- (NSUInteger)hash{
    return [self.name hash] ^ [self.address hash];
}

- (void)addPerson:(PFUser*)user withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.people];
    [arr insertObject:user.objectId atIndex:0];
    self.people = [NSArray arrayWithArray:arr];
    self.population = [NSNumber numberWithInt:[self.population intValue] + 1];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded || error) {
            [self saveEventually];
            completion(NO);
        }
        else{
            completion(YES);
        }
    }];
}

- (void)removePerson:(PFUser*)user withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.people];
    if ([arr containsObject:user.objectId]) {
        [arr removeObject:user.objectId];
        self.people = [NSArray arrayWithArray:arr];
        self.population = [NSNumber numberWithInt:(MAX([self.population intValue] - 1, 0))];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded || error) {
                [self saveEventually];
                completion(NO);
            }
            else{
                completion(YES);
            }
        }];
    }
}

- (void)addComment:(DCPlaceComment *)comment withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.comments];
    [arr insertObject:comment.objectId atIndex:0];
    self.comments = [NSArray arrayWithArray:arr];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
            completion(NO);
        }
        else{
            completion(YES);
        }
    }];
}

- (void)removeComment:(DCPlaceComment *)comment withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.comments];
    if ([arr containsObject:comment.objectId]) {
        [arr removeObject:comment.objectId];
        self.comments = [NSArray arrayWithArray:arr];
    }
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
            completion(NO);
        }
        else{
            completion(YES);
        }
    }];
}

- (void)addImage:(DCPlaceImage *)image withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.images];
    [arr insertObject:image.objectId atIndex:0];
    self.images = [NSArray arrayWithArray:arr];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
            completion(NO);
        }
        else{
            completion(YES);
        }
    }];
}

- (void)removeImage:(DCPlaceImage *)image withCompletion:(completion)completion{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.images];
    if ([arr containsObject:image.objectId]) {
        [arr removeObject:image.objectId];
        self.images = [NSArray arrayWithArray:arr];
    }
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
            completion(NO);
        }
        else{
            completion(YES);
        }
    }];
}

+ (void)createPlaceWithLocation:(PFGeoPoint*)location name:(NSString*)name address:(NSString*)address{
    DCPlace *place = [DCPlace object];
    place.name = name;
    place.address = address;
    place.location = location;
    place.type = @"bar";
    place.people = [NSMutableArray new];
    place.comments = [NSMutableArray new];
    place.population = 0;
    place.oldPopulation = 0;
    place.storedPopulation = 0;
    [place saveInBackground];
}


@end
