//
//  DCPlace.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/3/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import "DCPlaceComment.h"
#import "DCUserPointer.h"

@interface DCPlace : PFObject <PFSubclassing, CLLocationManagerDelegate>

/*Name and address of the place*/
@property (retain) NSString *name;
@property (retain) NSString *address;

/*Population represents the current population of the place
 *oldPopulation represents the population at this current time yesterday
 *storedPopulation is there to keep a reference to the old population
 so that when the time comes to actually set the old population, there
 is still a reference
 */
@property (retain) NSNumber *population;
@property (retain) NSNumber *oldPopulation;
@property (retain) NSNumber *storedPopulation;

/*The id of this place*/

@property (assign) NSNumber *placeId;

/*The location of the place*/
@property (retain) PFGeoPoint *location;

/*The type the place is
 *The type can only be bar or night club
 */
@property (retain) NSString *type;

/*An image of the place represented as a PFFile
 *Uses custom getters and setters to convert bewteen raw data
 and an actualy image
 */
@property (retain) PFFile *placeImage;

/*An array to hold all of the people that are currently there*/
@property (retain) NSMutableArray *people;

/*An array to hold all of the comments that are posted*/
@property (retain) NSMutableArray *comments;
@property (readonly,getter=getNumberOfComments) NSInteger *numberOfComments;

+(NSString*)parseClassName;

- (BOOL)isEqualToPlace:(DCPlace*)place;

- (void)addPerson:(PFUser*)user;
- (void)removePerson:(PFUser*)user;
- (void)addComment:(DCPlaceComment*)comment;
- (void)removeComment:(DCPlaceComment*)comment;

+ (void)createPlaceWithLocation:(PFGeoPoint*)location name:(NSString*)name address:(NSString*)address;

@end
