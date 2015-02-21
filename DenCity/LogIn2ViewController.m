//
//  LogIn2ViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "LogIn2ViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "DUIButton.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "DHNavigationController.h"
#import <Parse/Parse.h>
#import "FXBlurView.h"
#import <pop/POP.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LogIn2ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UIImageView *imageView;
}

//This property is the table view which hold the username and password textfields
@property (nonatomic, strong) UITableView *loginView;

/*these are both the textfields inside of the tableview which allow the user to enter
 in a password and username*/
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

/*This is just a text label that shows up near the bottom of the screen to give
 instructions on what the user can do*/
@property (nonatomic, strong) UILabel *textLabel;

/*This is another button and it allows for the user to "Just Go", which
 *is an anonymous login that takes you right to the main view
 */
@property (nonatomic, strong) DUIButton *button;
/*This is a button that will appear as just text
 *It will bring up a new view if the pressed, which
 will help the user retrieve their password
 */
@property (nonatomic, strong) UIButton *forgotButton;

/*This is a somewhat glitchy view that I implemented which is like a drop down banner
 that says when something is wrong. The label is just what the banner says*/
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation LogIn2ViewController

@synthesize loginView, usernameField, passwordField, textLabel, button, alertView, alertLabel, forgotButton;

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
    
    /*This method creates the rightBarButton and the reason for making a method for this is
     because when the user logs in an activity indicator replaces the rightBarButton, and if
     the login fails, instead of using many lines of code to recreate the barButton, I use this method*/
    [self createBarButton];
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [[UIImage imageNamed:@"city2.png"] blurredImageWithRadius:30 iterations:15 tintColor:[UIColor clearColor]];
    [self.view addSubview:imageView];
    
    /*This is a view with a tap gesture bound to it, and whenever this view is tapped,
     if the keyboard is on screen, it will be resigned*/
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
    
    //allocating and initializing the textlabel, centering it and adding it to the view
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 158, self.view.frame.size.width, 30)];
    textLabel.text = @"Log into your account or log in anonymously.";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    //allocating and initializing the anonymous login button, then adding it to the view
    button = [[DUIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - 113, self.view.frame.size.width - 100, 40) fontSize:18 whiteValue:100];
    [button setTitle:@"Just Go" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 4.0f;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //creating the forgot password button
    forgotButton = [[UIButton alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height - 38, self.view.frame.size.width - 120, 20)];
    forgotButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [forgotButton addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
    
    /*This is a view that is 1 point high and acts as a separator in the main view between logging
     in with a username and password, or logging in anonymously*/
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height - 168, self.view.frame.size.width - 10, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
    /*allocating and initializing the alert banner, then adding it to the view. It is
     hidden at first because it only appears when an error occurs.*/
    alertView = [[UIView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width, 64, self.view.frame.size.width, 40)];
    alertView.backgroundColor = UIColorFromRGB(0x400040);
    alertView.alpha = 0;
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:alertLabel];
    for (UIView *view in alertView.subviews){
        if (view != alertLabel){
            view.alpha = .5;
        }
    }
    [self.view addSubview:alertView];
    
    //allocating and initializing the tableview, and adding it to the view
    loginView = [[UITableView alloc]initWithFrame:CGRectMake(-1, 114, self.view.frame.size.width + 2, 88) style:UITableViewStyleGrouped];
    loginView.backgroundColor = [UIColor clearColor];
    loginView.separatorColor = [UIColor whiteColor];
    loginView.scrollEnabled = NO;
    loginView.allowsSelection = NO;
    loginView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    loginView.delegate = self;
    loginView.dataSource = self;
    
    [self.view addSubview:loginView];
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
}

/*This method handles when the user wants to retrieve their password
 incase they forgot it
 */
- (void)forgotPassword{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Recover Password" message:@"Enter the email address linked with your account." preferredStyle:UIAlertControllerStyleAlert];
    alert.modalPresentationStyle = UIModalPresentationPopover;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email Address";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [PFUser requestPasswordResetForEmailInBackground:[alert.textFields[0] text] block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self showAlertViewWithErrorMessage:@"Email has been sent"];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [self showAlertViewWithErrorMessage:@"Couldn't Find Email Address"];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/*This method resigns whichever textfield is active, when the tapView is tapped*/
- (void)tapped{
    if (usernameField.isFirstResponder) {
        [usernameField resignFirstResponder];
    }
    if (passwordField.isFirstResponder) {
        [passwordField resignFirstResponder];
    }
}

- (void)login{
    //If a user is logged in, log them out -> But There shouldnt be anyone logged in
    [PFUser logOut];
    
    //checking to make sure that they entered a username and password so that we dont have to use data
    if ([usernameField.text isEqualToString:@""]) {
        [self showAlertViewWithErrorMessage:@"Please enter your username"];
    }
    else if ([passwordField.text isEqualToString:@""]) {
        [self showAlertViewWithErrorMessage:@"Please enter your password"];
    }
    else{
        //Once username and password are checked, the righBarButton is repalced with the activity indicator
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:av];
        [av startAnimating];
        //this is just for testing purposes, when I have no internet access
        if ([usernameField.text isEqualToString:@"admin"] && [passwordField.text isEqualToString:@"password"]) {
            [self loggedIn];
            return;
        }
        //This uses Parse to log in the user based on their username and password
        [PFUser logInWithUsernameInBackground:usernameField.text password:passwordField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self loggedIn];
                                            } else if (error.code == 101){
                                                [self showAlertViewWithErrorMessage:@"Invalid Login Credentials"];
                                                [self createBarButton];
                                            }
                                            else{
                                                [self showAlertViewWithErrorMessage:@"Check Network Connection"];
                                                [self createBarButton];
                                            }
                                        }];
    }
}

//This method is very similar to the login method, except it just logs in anonymously
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
            [self showAlertViewWithErrorMessage:@"Check Network Connection"];
            [self createBarButton];
            [av stopAnimating];
        }
    }];
    
}

//This method is called if a succesful log in occurs, whether it be anonymous or not
/*It swaps out the center view controller with a new nav controller,
 whos root viewController is the mainViewController*/
- (void)loggedIn{
    MainViewController *mv = [[MainViewController alloc]init];
    mv.view.alpha = 0;
    MenuViewController *meV = [[MenuViewController alloc]init];
    meV.delegate = (id<menuViewControllerDelegate>)mv;
    DHNavigationController *nav = [[DHNavigationController alloc]initWithRootViewController:mv];
    [nav setViewControllers:@[mv] animated:NO];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.barTintColor = [UIColor colorWithWhite:.15 alpha:1];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent = NO;
    [self.mm_drawerController setLeftDrawerViewController:meV];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{mv.view.alpha = 1;}];
    }];
    [self.mm_drawerController setShowsShadow:YES];
    [self.mm_drawerController setShouldStretchDrawer:YES];
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:5]];
    self.mm_drawerController.maximumRightDrawerWidth = [UIScreen mainScreen].bounds.size.width;
    
}

//This method handles the banner animation and its text
- (void)showAlertViewWithErrorMessage:(NSString*)error{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    button.userInteractionEnabled = NO;
    alertLabel.text = error;
    alertView.alpha = 1;
    CGRect currentFrame = alertView.frame;
    CGRect middleFrame = CGRectMake(0, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    CGRect endFrame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:3 initialSpringVelocity:4 options:UIViewAnimationOptionCurveLinear animations:^{
        [alertView setFrame:middleFrame];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
            [alertView setFrame:endFrame];
        }completion:^(BOOL finished){
            self.navigationItem.rightBarButtonItem.enabled = YES;
            button.userInteractionEnabled = YES;
            alertView.alpha = 0;
            [alertView setFrame:currentFrame];
        }];
    }];
}

//method creates the rightBarButton
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
        /*This is where the textfields are created and added into the table view cells*/
        cell.imageView.image = [UIImage imageNamed:@"username@2x.png"];
        usernameField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
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
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
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
