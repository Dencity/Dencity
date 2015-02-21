//
//  LogIn2ViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "LogIn2ViewController.h"
#import "MainViewController.h"
#import "ShrinkButton.h"
#import <Parse/Parse.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LogIn2ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *loginView;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) ShrinkButton *button;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation LogIn2ViewController

@synthesize loginView, usernameField, passwordField, textLabel, button, alertView, alertLabel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"city2.png"]];
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 410, 320, 30)];
        textLabel.text = @"Log into your account or log in anonymously.";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:textLabel];
        
        button = [[ShrinkButton alloc]initWithFrame:CGRectMake(50, 455, 220, 40)];
        [button setTitle:@"Just Go" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.cornerRadius = 4.0f;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 400, 310, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:line];
        
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 114 + 88, 320, 200)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
        [tapView addGestureRecognizer:tap];
        [self.view addSubview:tapView];
        
        UIView *tapView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 50)];
        tapView2.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
        [tapView2 addGestureRecognizer:tap2];
        [self.view addSubview:tapView2];
        
        alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 24, 320, 40)];
        alertView.backgroundColor = UIColorFromRGB(0x400040);
        alertView.alpha = 0;
        alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.font = [UIFont systemFontOfSize:15];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [alertLabel setCenter:CGPointMake(160, 20)];
        [alertView addSubview:alertLabel];
        [self.view addSubview:alertView];
        
        [self.view bringSubviewToFront:tapView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBarButton];
        
    loginView = [[UITableView alloc]initWithFrame:CGRectMake(-1, 114, 322, 88) style:UITableViewStyleGrouped];
    loginView.backgroundColor = [UIColor clearColor];
    loginView.separatorColor = [UIColor whiteColor];
    loginView.contentInset = UIEdgeInsetsMake(-99, 0, 0, 0);
    loginView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    loginView.scrollEnabled = NO;
    loginView.allowsSelection = NO;
    loginView.delegate = self;
    loginView.dataSource = self;
    
    [self.view addSubview:loginView];
    
    [self.view bringSubviewToFront:loginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)tapped{
    if (usernameField.isFirstResponder) {
        [usernameField resignFirstResponder];
    }
    if (passwordField.isFirstResponder) {
        [passwordField resignFirstResponder];
    }
}

- (void)login{
    [PFUser logOut];
    if ([usernameField.text isEqualToString:@""]) {
        [self showAlertViewWithErrorMessage:@"Please enter your username"];
    }
    else if ([passwordField.text isEqualToString:@""]) {
        [self showAlertViewWithErrorMessage:@"Please enter your password"];
    }
    else{
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:av];
        [av startAnimating];
        [PFUser logInWithUsernameInBackground:usernameField.text password:passwordField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self loggedIn];
                                            } else {
                                                [self showAlertViewWithErrorMessage:@"Invalid login credentials"];
                                                [self createBarButton];
                                            }
                                        }];
    }
}

- (void)go{
    [PFUser logOut];
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:av];
    [av startAnimating];
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error){
        if (user) {
            [self loggedIn];
        }
        else{
            [self showAlertViewWithErrorMessage:@"An unexpected error occured"];
#warning This is here just for when theres no internet
            [self loggedIn];
            [self createBarButton];
        }
    }];
}

- (void)loggedIn{
    MainViewController *mv = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mv];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.barTintColor = [UIColor clearColor];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)showAlertViewWithErrorMessage:(NSString*)error{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    alertLabel.text = error;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            alertView.frame = CGRectMake(0, 64, 320, 40);
            alertView.alpha = 1;
            alertLabel.alpha = 1;
        } completion:nil];
    [UIView animateWithDuration:.3 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
        alertView.frame = CGRectMake(0, 24, 320, 40);
        alertView.alpha = 0;
        alertLabel.alpha = 0;
    } completion:^(BOOL finished){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)createBarButton{
    UIImage *forwardImage = [UIImage imageNamed:@"forward1.png"];
    UIButton *forward = [UIButton buttonWithType:UIButtonTypeCustom];
    [forward setImage:forwardImage forState:UIControlStateNormal];
    forward.frame = CGRectMake(0, 0, forwardImage.size.width, forwardImage.size.height);
    [forward addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]initWithCustomView:forward];
    self.navigationItem.rightBarButtonItem = forwardButton;
}

//------------------------------------------------UITableViewDelegate and Datasource-----------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"username@2x.png"];
        usernameField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, 321, 44)];
        usernameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        usernameField.borderStyle = UITextBorderStyleNone;
        usernameField.textColor = [UIColor whiteColor];
        usernameField.backgroundColor = [UIColor clearColor];
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.delegate = self;
        [cell.contentView addSubview:usernameField];
    }
    if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"password@2x.png"];
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, 321, 44)];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        passwordField.secureTextEntry = YES;
        passwordField.borderStyle = UITextBorderStyleNone;
        passwordField.textColor = [UIColor whiteColor];
        passwordField.backgroundColor = [UIColor clearColor];
        passwordField.returnKeyType = UIReturnKeyDone;
        passwordField.delegate = self;
        [cell.contentView addSubview:passwordField];
    }
    return cell;
}

//-----------------------------------------------------UITextFieldDelegate---------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
    if (textField == passwordField) {
        [self login];
        [passwordField resignFirstResponder];
    }
    return YES;
}

@end
