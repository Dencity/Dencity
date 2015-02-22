//
//  DCPlace.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/3/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlace.h"
#import <Parse/PFObject+Subclass.h>

@interface DCPlace (){
    PFGeoPoint *currentLocation;
}

@end

@implementation DCPlace

@dynamic name, address, population, oldPopulation, storedPopulation, location, type, people, comments, numberOfComments, placeId, placeImage;

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

- (void)addPerson:(PFUser*)user{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.people];
    [arr addObject:user.objectId];
    self.people = arr;
    self.population = [NSNumber numberWithInt:[self.population intValue] + 1];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded || error) {
            [self saveEventually];
        }
    }];}

- (void)removePerson:(PFUser*)user{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.people];
    if ([arr containsObject:user.objectId]) {
        [arr removeObject:user.objectId];
        self.people = arr;
        self.population = [NSNumber numberWithInt:(MAX([self.population intValue] - 1, 0))];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded || error) {
                [self saveEventually];
            }
        }];
    }
}

- (NSInteger)getnumberOfComments{
    return self.comments.count;
}

- (void)addComment:(DCPlaceComment *)comment{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.comments];
    [arr addObject:comment];
    self.comments = arr;
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
        }
    }];
}

- (void)removeComment:(DCPlaceComment *)comment{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.comments];
    if ([arr containsObject:comment]) {
        [arr removeObject:comment];
        self.comments = arr;
    }
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self saveEventually];
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
