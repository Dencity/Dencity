//
//  DataGatherer.m
//  DenCity
//
//  Created by Dylan Humphrey on 10/3/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import "DataGatherer.h"
#import "DCPlace.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static const NSString *appID = @"AIzaSyDa8Ulb6WozDqAa-VBr6GNQS7X2rpAYQgw";
static int placeId = 0;

@implementation DataGatherer

- (void)places{
    //NSArray *coords = [self coordinatesForCityFromLatitude:@"34.05" Longitude:@"118.25"];
    
    NSArray *coords = [[NSArray alloc]initWithObjects:@"34.043212",@"-118.2499534",
                                                      @"34.0485957",@"-118.2815993",
                                                      @"34.0848038",@"-118.2942593",
                                                      @"34.0908637",@"-118.3333552",
                                                      @"34.0510669",@"-118.3366168",
                                                      @"34.0456932",@"-118.3734274",
                                                      @"34.0844173",@"-118.3729124",
                                                      @"34.0470944",@"-118.3715594",
                                                      @"34.0433518",@"-118.3985961",
                                                      @"34.0597968",@"-118.4367478",
                                                      @"34.037013",@"-118.4289372",
                                                      @"34.0339812",@"-118.4582913",
                                                      @"34.0523392",@"-118.4812725",
                                                      @"34.0274291",@"-118.4992625",
                                                      @"34.0132189",@"-118.4897782",
                                                      @"33.9875155",@"-118.4617151",
                                                      @"34.0036334",@"-118.4244646",
                                                      @"34.0058995" ,@"-118.4090245",
                                                      @"33.983655",@"-118.3055636",
                                                      @"33.9789675",@"-118.2140149",
                                                      @"34.0351659",@"-118.1596355",
                                                      @"34.0925301",@"-118.2680144",
                                                      @"33.969717",@"-118.3999095",
                                                      @"34.0442315",@"-118.5268144",
                                                      nil];
    
    for (int i = 0; i < coords.count/2; i+=2) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSString * url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=1500&types=bar&sensor=true_or_false&key=%@",coords[i],coords[i+1],appID];
        NSURL *request = [NSURL URLWithString:url];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:request];
            NSError *error;
            NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];       
            [array addObjectsFromArray:[json objectForKey:@"results"]];
        
            for (NSDictionary *place in array) {
                PFQuery *q = [DCPlace query];
                [q whereKey:@"name" equalTo:[place objectForKey:@"name"]];
                [q getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                    if (!object) {
                        NSLog(@"changing place %@",[place objectForKey:@"name"]);
                        
                        //initializing the place object from the data base
                        DCPlace *obj = [DCPlace object];
                        
                        //setting the name and address of the place
                        obj.name = [place objectForKey:@"name"];
                        obj.address = [place objectForKey:@"vicinity"];
                        
                        //setting the map coordinate of the place
                        NSDictionary *location = [[place objectForKey:@"geometry"] objectForKey:@"location"];
                        
                        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[[location objectForKey:@"lat"] doubleValue] longitude:[[location objectForKey:@"lng"] doubleValue]];
                        obj.location = point;
                        
                        //setting the photo of the place
                        NSArray *photoArray = [place objectForKey:@"photos"];
                        if (photoArray.count > 0) {
                            NSDictionary *photo = [photoArray objectAtIndex:0];
                            NSString *photoRef = [photo objectForKey:@"photo_reference"];
                            NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=640&photoreference=%@&sensor=true_or_false&key=%@",photoRef, appID];
                            NSURL *request = [NSURL URLWithString:url];
                            NSData* data = [NSData dataWithContentsOfURL:request];
                            PFFile *photoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%iPhoto", placeId] data:data];
                            obj.placeImage = photoFile;
                        }
                        
                        //setting the id of the place and making the blank array
                        obj.placeId = [NSNumber numberWithInt:placeId];
                        obj.oldPopulation = nil;
                        obj.storedPopulation = nil;
                        placeId++;
                        obj.people = [[NSMutableArray alloc]init];
                        obj.comments = [[NSMutableArray alloc]init];
                        obj.type = @"bar";
                        
                        //save the object to the online database
                        [obj saveInBackground];
                    }
                }];
                
            }
        });
    }
}

/*this method will get passed a coordinate and will return an array of coordinates
 *each coordinate in this array will be spaced out by a little less than 100m
 *this is just a helper method for above so that places can be recorded much more accurately
 */
- (NSArray*)coordinatesForCityFromLatitude:(NSString*)latitude Longitude:(NSString*)longitude{
    return nil;
}
@end
