//
//  CreateViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 6/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "CreateViewController.h"
#import "Create2ViewController.h"
#import <Parse/Parse.h>
#import "FXBlurView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CreateViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    BOOL email;
    BOOL username;
    BOOL networkConnection;
    
    BOOL animating;
    
    UIImageView *imageView;
}

/*This is just the table view that holds the username, email, and password
 text fields, hence the name uEP*/
@property (nonatomic, strong) UITableView *uEP;

/*The three text fields that appear in the table view. All
 are allocated in the cellForRowAtIndexPath method of the
 tableview datasource*/
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

/*This is a somewhat glitchy view that I implemented which is like a drop down banner
 that says when something is wrong. The label is just what the banner says*/
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation CreateViewController

@synthesize uEP, usernameField, passwordField, emailField, alertView, alertLabel;

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
    imageView.image = [[UIImage imageNamed:@"city3"] blurredImageWithRadius:30 iterations:15 tintColor:[UIColor clearColor]];
    [self.view addSubview:imageView];
    
    //the tapview is created here to grant easy access to dismissing the keyboard
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
    
    //creating the alert view
    alertView = [[UIView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width, 64, self.view.frame.size.width, 40)];
    alertView.backgroundColor = UIColorFromRGB(0x400040);
    alertView.alpha = 0;
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:alertLabel];
    [self.view addSubview:alertView];
    
    //This is the table view
    uEP = [[UITableView alloc]initWithFrame:CGRectMake(-1, 115, self.view.frame.size.width + 2, 132) style:UITableViewStyleGrouped];
    uEP.backgroundColor = [UIColor clearColor];
    uEP.separatorColor = [UIColor whiteColor];
    uEP.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    uEP.scrollEnabled = NO;
    uEP.allowsSelection = NO;
    uEP.delegate = self;
    uEP.dataSource = self;
    
    [self.view addSubview:uEP];
    
    //setting the bar button images
    //creating the forward bar button item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(next)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/*This method is called when the forward button is pressed and checks to make
 sure all fields are in order everything is ready for the next step*/
- (void)next{
    if ([emailField.text isEqualToString:@""]) {
        [self showAlertViewWithErrorMessage:@"Please enter an email address"];
    }
    else if ([usernameField.text isEqualToString:@""]){
        [self showAlertViewWithErrorMessage:@"Please enter a username"];
    }
    else if ([passwordField.text isEqualToString:@""]){
        [self showAlertViewWithErrorMessage:@"Please enter a password"];
    }
    else if (!networkConnection){
        [self showAlertViewWithErrorMessage:@"No Network Connection"];
    }
    else if (!email){
        [self showAlertViewWithErrorMessage:@"Email is already in use"];
    }
    else if (!username){
        [self showAlertViewWithErrorMessage:@"Username already exists"];
    }
    else if ([self checkPassword] == nil && [self checkUsername] && [self checkEmail]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        Create2ViewController *cv = [[Create2ViewController alloc]init];
        cv.email = self.emailField.text;
        cv.username = usernameField.text;
        cv.password = passwordField.text;
        [self.navigationController pushViewController:cv animated:YES];
    }
    else{
        [self showAlertViewWithErrorMessage:@"Please fix red fields"];
    }
}
/*This method is for showing the alert view and when it is called a view 40 points high
 is animated down from the navigation bar holding the string parameter*/
- (void)showAlertViewWithErrorMessage:(NSString*)error{
    
    if (animating) {
        [self performSelector:@selector(showAlertViewWithErrorMessage:) withObject:error afterDelay:2];
        return;
    }
    
    animating = YES;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
            alertView.alpha = 0;
            [alertView setFrame:currentFrame];
            animating = NO;
        }];
    }];
}

/*This method is for the tapview and is called when the tap view is pressed 
 so that the keyboard will hide*/
- (void)tapped{
    if (emailField.isFirstResponder) {
        [emailField resignFirstResponder];
    }
    if (usernameField.isFirstResponder) {
        [usernameField resignFirstResponder];
    }
    if (passwordField.isFirstResponder) {
        [passwordField resignFirstResponder];
    }
}
/*This method cheks the email address to see if its valid or not and will return
 a boolean value whether it is valid or not -> email must contain a '.' and a '@'symbol
 but there must be at least 1 letter before the '@' and before/after the '.'
 Ex. d@.com --> return NO  Ex. d@d.d --> return YES*/
- (BOOL)checkEmail{
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:emailField.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            email = YES;
            networkConnection = YES;
        }
        else if (object){
            emailField.textColor = [UIColor redColor];
            [self showAlertViewWithErrorMessage:@"Email is already in use"];
            email = NO;
            networkConnection = YES;
            return;
        }
        else{
            [self showAlertViewWithErrorMessage:@"Check Network Connection"];
            networkConnection = NO;
        }
    }];
    if ([emailField.text containsString:@"@"] && [emailField.text containsString:@"."]){
        NSArray *substrings = [emailField.text componentsSeparatedByString:@"@"];
        NSArray *substrings1 = [emailField.text componentsSeparatedByString:@"."];
        if ([substrings[0] isEqualToString:@""]) {
            emailField.textColor = [UIColor redColor];
            return NO;
        }
        if ([substrings1[1] isEqualToString:@""]) {
            emailField.textColor = [UIColor redColor];
            return NO;
        }
        if ([substrings[1] characterAtIndex:0] == '.'){
            emailField.textColor = [UIColor redColor];
            return NO;
        }
        emailField.textColor = [UIColor whiteColor];
        return YES;
    }
    else if ([emailField.text isEqualToString:@""]){
        emailField.textColor = [UIColor whiteColor];
        return YES;
    }
    else{
        emailField.textColor = [UIColor redColor];
        return NO;
    }
    return NO;
}
/*Same thing as the above method just for the username*/
- (BOOL)checkUsername{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:usernameField.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error.code == 100) {
            [self showAlertViewWithErrorMessage:@"Check Network Connection"];
            networkConnection = NO;
        }
        if (!object){
            usernameField.textColor = [UIColor whiteColor];
            username = YES;
            networkConnection = YES;
        }
        else if (object){
            usernameField.textColor = [UIColor redColor];
            [self showAlertViewWithErrorMessage:@"Username already exists"];
            username = NO;
            networkConnection = YES;
            return;
        }
    }];
    return YES;
}

/*This method returns a string which will be the error because there can be two different
 things wrong with the password. If the password is usable the method will return nil
 but if the password is not usable the method will return the error message*/
- (NSString*)checkPassword{
    NSString *password = passwordField.text;
    if (password.length == 0) {
        return nil;
    }
    int count = 0;
    for (int i = 0; i < 10; i++) {
        if ([password containsString:[NSString stringWithFormat:@"%i", i]]) {
            count++;
        }
    }
    if (password.length > 5 && count > 0) {
        passwordField.textColor = [UIColor whiteColor];
        return nil;
    }
    if (password.length <= 5) {
        passwordField.textColor = [UIColor redColor];
        return @"Password must be at least 5 characters";
    }
    if (count == 0) {
        passwordField.textColor = [UIColor redColor];
        return @"Password must contain at least 1 number";
    }
    return nil;
}

//------------------------------------------------UITableViewDelegate and Datasource-----------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"email@2x.png"];
        emailField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
        emailField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        emailField.borderStyle = UITextBorderStyleNone;
        emailField.textColor = [UIColor whiteColor];
        emailField.backgroundColor = [UIColor clearColor];
        emailField.returnKeyType = UIReturnKeyNext;
        emailField.delegate = self;
        [cell.contentView addSubview:emailField];
    }
    if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"username@2x.png"];
        usernameField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
        usernameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Choose a username" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        usernameField.borderStyle = UITextBorderStyleNone;
        usernameField.textColor = [UIColor whiteColor];
        usernameField.backgroundColor = [UIColor clearColor];
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.delegate = self;
        [cell.contentView addSubview:usernameField];
    }
    if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"password@2x.png"];
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Choose a password" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == emailField) {
        [usernameField becomeFirstResponder];
    }
    if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
    if (textField == passwordField) {
        [passwordField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == emailField) {
        if ([self checkEmail] == NO){
            [self showAlertViewWithErrorMessage:@"Please enter a valid email"];
        }
    }
    if (textField == usernameField) {
        [self checkUsername];
    }
    if (textField == passwordField){
        NSString *str = [self checkPassword];
        if (str != nil) {
            [self showAlertViewWithErrorMessage:str];
        }
    }
}

@end
