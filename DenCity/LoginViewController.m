//
//  LoginViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/26/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "LoginViewController.h"
#import "DUIButton.h"
#import "LogIn2ViewController.h"
#import "CreateViewController.h"
#import "Create2ViewController.h"
#import "DataViewController.h"
#import "MYBlurIntroductionView.h"
#import "LocationPanel.h"
#import "ServicePanel.h"
#import "MYIntroductionPanel.h"
#import "FXBlurView.h"


@interface LoginViewController (){
    UIImageView *imageView;
}

/*This property is the title of the logo that appears on the main screen*/
@property (nonatomic, strong) UILabel *titleLabel;

/*This is a custom button created which allows the user to sign in*/
@property (nonatomic, strong) DUIButton *signInWithEmail;

/*This is a custom button created which allows the user to sign up*/
@property (nonatomic, strong) DUIButton *signUp;

@property (nonatomic, strong) DUIButton *data;

@end

@implementation LoginViewController

@synthesize signInWithEmail, signUp, titleLabel, data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    imageView.image = [[UIImage imageNamed:@"city"] blurredImageWithRadius:30 iterations:15 tintColor:[UIColor clearColor]];
    [self.view addSubview:imageView];
    
    data = [[DUIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 175, self.view.bounds.size.width - 20, 45)
                                  fontSize:18
                                whiteValue:.15f];
    [data setTitle:@"Manage Data" forState:UIControlStateNormal];
    [data setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    data.layer.cornerRadius = 4.0;
    [data addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:data];
    
    //allocating and initializing the title label, then adding it to the view
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)];
    titleLabel.font = [UIFont boldSystemFontOfSize:50];
    titleLabel.text = @"DenCity";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    
    //allocating and initializing the sign up button, then adding it to the view
    signUp = [[DUIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 110, self.view.bounds.size.width - 20, 45)
                                    fontSize:18
                                  whiteValue:.15];
    [signUp setTitle:@"Register with Email" forState:UIControlStateNormal];
    [signUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUp.layer.cornerRadius = 4.0;
    [signUp addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signUp];
    
    //allocating and initializing the sign in button, then adding it to the view
    signInWithEmail = [[DUIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 55, self.view.bounds.size.width - 20, 45)
                                             fontSize:18
                                           whiteValue:.15];
    [signInWithEmail setTitle:@"Log In" forState:UIControlStateNormal];
    [signInWithEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signInWithEmail.layer.cornerRadius = 4.0;
    [signInWithEmail addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signInWithEmail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //this code makes sure that whenever this view appears, the navigation bar and status bar are hidden
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //this code makes sure that whenever this view appears, the navigation bar and status bar are hidden
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"filter"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LocationPanel *panel = [[LocationPanel alloc]initWithFrame:[UIScreen mainScreen].bounds
                                                             title:@"Welcome to Dencity"
                                                       description:@"This application requires the use of location service in order check if you have entered a club or a bar. After pressing the enable button below, please be sure to allow Dencity to monitor you location"];
        MYBlurIntroductionView *introView = [[MYBlurIntroductionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [introView buildIntroductionWithPanels:@[panel]];
        introView.BackgroundImageView.image = [[UIImage imageNamed:@"city"] blurredImageWithRadius:50 iterations:10 tintColor:[UIColor clearColor]];
        [introView.RightSkipButton setTitle:@"Finish" forState:UIControlStateNormal];
        CGRect frame = introView.RightSkipButton.frame;
        frame.origin.x -= 12;
        frame.size.width += 12;
        introView.RightSkipButton.frame = frame;
        [self.view addSubview:introView];
    }
    else if (![[NSUserDefaults standardUserDefaults]boolForKey:@"HasAllowedLocation"]){
        ServicePanel *panel = [[ServicePanel alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"Enable Location Services" description:@"This application requires the use of location services to function. Please go to Settings > Privacy > Location Services > Dencity and press 'always allow'. "];
        MYBlurIntroductionView *introView = [[MYBlurIntroductionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [introView buildIntroductionWithPanels:@[panel]];
        introView.BackgroundImageView.image = [[UIImage imageNamed:@"city"] blurredImageWithRadius:50 iterations:10 tintColor:[UIColor clearColor]];
        introView.RightSkipButton = nil;
        CGRect frame = introView.RightSkipButton.frame;
        frame.origin.x -= 12;
        frame.size.width += 12;
        introView.RightSkipButton.frame = frame;
        [self.view addSubview:introView];
    }


}

- (void)buttonPressed:(id)sender{
    
    //pushes a new view controller onto the navigation stack based on which button was pressed
    if (sender == signUp){
        CreateViewController *cv = [[CreateViewController alloc]init];
        [self.navigationController pushViewController:cv animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (sender == signInWithEmail){
        LogIn2ViewController *lv = [[LogIn2ViewController alloc]init];
        [self.navigationController pushViewController:lv animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (sender == data) {
        DataViewController *dv = [[DataViewController alloc]init];
        [self presentViewController:dv animated:YES completion:nil];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
