//
//  ProfileViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 8/19/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

- (id)initWithPerson:(PFUser*)person;

@end
