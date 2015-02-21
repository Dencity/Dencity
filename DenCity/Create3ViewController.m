//
//  Create3ViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 8/4/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import "Create3ViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface Create3ViewController (){
    UIImageView *imageView;
}

@end

@implementation Create3ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"night.png"];
    [self.view addSubview:imageView];
    
    //creating the forward bar button item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    
    //adding the button to cancel the sign up process
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cancel.png"] style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/*method is called when the user tries to go next
 No need to check parameters because previous view controllers
 have already checked to make sure that all parameters are good.
 Uses a 3rd party library to show that user account is being made*/
- (void)next{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"Creating" maskType:SVProgressHUDMaskTypeClear];
    PFUser *user = [PFUser user];
    user.email = self.email;
    user.username = self.username;
    user.password = self.password;
    user[@"birthday"] = self.birthday;
    user[@"name"] = self.name;
    user[@"gender"] = @(self.gender);
    user[@"isIn"] = @NO;
    
    if (self.profPic) {
        NSData *imageData = UIImagePNGRepresentation(self.profPic);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@ProfilePicture.png",self.username] data:imageData];
        
        user[@"ProfPic"] = imageFile;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (success){
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:nil afterDelay:1];            
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"Error"];
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:nil afterDelay:1];
        }
    }];
}

- (void)cancel{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
