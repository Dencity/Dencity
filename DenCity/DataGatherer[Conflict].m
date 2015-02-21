//
//  DataGatherer.m
//  DenCity
//
//  Created by Dylan Humphrey on 10/3/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import "DataGatherer.h"

#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static const NSString *appID = @"AIzaSyDa8Ulb6WozDqAa-VBr6GNQS7X2rpAYQgw";

@implementation DataGatherer

- (void)places{
    NSArray *coords = [[NSArray alloc]initWithObjects:@"34.043212",@"-118.2499534",
                                                      @"34.0485957",@"-118.2815993",
                                                      @"34.0848038",@"-118.2942593",
                                                      @"34.0908637",@"-118.3333552",
                                                      @"34.0510669",@"-118.3366168",
                                                      @"",@"",
                                                      @"",@"",
                                                      @"",@"",
                                                      @"",@"",
                                                      @"",@"",
                                                      @"",@"",
                                                      @"",@"",
                                                      nil];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < coords.count/2; i+=2) {
        
        NSString * url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=1000&types=bar&sensor=true_or_false&key=%@",coords[i],coords[i+1],appID];
        NSURL *request = [NSURL URLWithString:url];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:request];
        
            NSError *error;
        
            if (error) {
                NSLog(@"%@",error);
            }
            else{
                NSLog(@"Downloading places");
            }
        
            NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];       
            [array addObjectsFromArray:[json objectForKey:@"results"]];
            NSLog(@"%lu",(unsigned long)array.count);
        
            for (NSDictionary *place in array) {
            
                NSLog(@"changing place %@",[place objectForKey:@"name"]);
            
                //initializing the place object from the data base
                PFObject *obj = [PFObject objectWithClassName:@"Place"];
            
                //setting the name and address of the place
                obj[@"name"] = [place objectForKey:@"name"];
                obj[@"address"] = [place objectForKey:@"vicinity"];
            
                //setting the map coordinate of the place
                NSDictionary *location = [[place objectForKey:@"geometry"] objectForKey:@"location"];
            
                PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[[location objectForKey:@"lat"] doubleValue] longitude:[[location objectForKey:@"lng"] doubleValue]];
                obj[@"location"] = point;
            
                //setting the photo of the place
                NSArray *photoArray = [place objectForKey:@"photos"];
                if (photoArray.count > 0) {
                    NSDictionary *photo = [photoArray objectAtIndex:0];
                    NSString *photoRef = [photo objectForKey:@"photo_reference"];
                    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=640&photoreference=%@&sensor=true_or_false&key=%@",photoRef, appID];
                    NSURL *request = [NSURL URLWithString:url];
                    NSData* data = [NSData dataWithContentsOfURL:request];
                    NSString *firstName = [[place objectForKey:@"name"]componentsSeparatedByString:@" "][0];
                    PFFile *photoFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@Photo", firstName] data:data];
                    obj[@"image"] = photoFile;
                }
            
                //setting the id of the place and making the blank array
                obj[@"placeId"] = place[@"place_id"];
                obj[@"people"] = [[NSArray alloc]init];
                obj[@"population"] = @0;
            
                //save the object to the online database
                [obj saveInBackground];
            }
        });
    }
}
@end
