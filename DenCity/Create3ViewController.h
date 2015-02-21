//
//  Create3ViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 8/4/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Create3ViewController : UIViewController

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readwrite) BOOL gender;
@property (nonatomic, strong) UIImage *profPic;

@end
