//
//  PlaceViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 9/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "JPBFloatingTextViewController.h"

@interface PlaceViewController : JPBFloatingTextViewController

@property (nonatomic, strong) PFObject *place;

- (id)initWithPlace:(NSString*)place;

@end
