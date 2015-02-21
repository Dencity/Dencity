//
//  ProfileViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 8/19/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "DHNavigationController.h"
#import <Parse/Parse.h>
#import "UIViewController+MMDrawerController.h"

@interface ProfileViewController ()

@property (nonatomic, strong) PFImageView *profilePictureView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;

@property (nonatomic ,strong) UIButton *editButton;

@end

@implementation ProfileViewController

@synthesize profilePictureView, nameLabel, ageLabel, editButton;

#pragma mark - Initialization

- (id)init{
    self = [super init];
    if (self) {
        self.user = [PFUser currentUser];
    }
    return self;
}

- (id)initWithPerson:(PFUser *)person{
    self = [super init];
    if (self){
        self.user = person;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
