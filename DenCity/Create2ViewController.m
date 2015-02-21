//
//  Create2ViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 7/2/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "Create2ViewController.h"
#import "DUIButton.h"
#import "Create3ViewController.h"
#import "FXBlurView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Create2ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImageView *imageView;
}

/*These are both of the text fields that will show up in the table view, one
 for the entering the users birthday, one for their full name*/
@property (nonatomic, strong) UITextField *birthdayField;
@property (nonatomic, strong) UITextField *nameField;

/*The main tableview which holds all the text fields and
 what not*/
@property (nonatomic, strong) UITableView *tableView;

/*This is a somewhat glitchy view that I implemented which is like a drop down banner
 that says when something is wrong. The label is just what the banner says*/
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *alertLabel;

/*The segmented control the user will use to select the gender
 in the table view*/
@property (nonatomic, strong) UISegmentedControl *gender;

/*If the user chooses to create a profile picture, this will allow
 them to pick a picture or take one*/
@property (nonatomic, strong) UIImagePickerController *imagePicker;

/*The button that allows the user to create a profile picture*/
@property (nonatomic, strong) DUIButton *pB;

@end

@implementation Create2ViewController

@synthesize birthdayField, tableView, nameField, alertLabel, alertView, gender, imagePicker, pB;

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
    imageView.image = [[UIImage imageNamed:@"city4"] blurredImageWithRadius:30 iterations:15 tintColor:[UIColor clearColor]];
    [self.view addSubview:imageView];
    
    //These are both tap views just added for ease of use -> They dismiss the keyboard
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
    
    
    //creating the alert view that will drop down from the top of the screen
    alertView = [[UIView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width, 64, self.view.frame.size.width, 40)];
    alertView.backgroundColor = UIColorFromRGB(0x400040);
    alertView.alpha = 0;
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [alertLabel setCenter:CGPointMake(160, 20)];
    [alertView addSubview:alertLabel];
    [self.view addSubview:alertView];
    
    //creating the forward bar button item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    
    //adding the button to cancel the sign up process
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cancel.png"] style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
    
    //the main tableview which holds the text fields and the segemented control
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(-1, 115, self.view.frame.size.width + 2, 132) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    //just a line for ui looks
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height - 85, self.view.frame.size.width - 10, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];

    //creating the button that allows the user to get a profile picture
    pB = [[DUIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height - 75, 60, 60) fontSize:14 whiteValue:100];
    pB.layer.cornerRadius = 60/2;
    pB.layer.borderColor = [UIColor whiteColor].CGColor;
    pB.layer.borderWidth = 4.0f;
    [pB setTitle:@"Photo" forState:UIControlStateNormal];
    [pB addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    pB.clipsToBounds = YES;
    [self.view addSubview:pB];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//this method is called when the nav controller pushes the next view controller.
/*It just makes sure that all fields are entered and has some logic to see which
gender was picked and if there is a profile picture*/
- (void)next{
    if ([birthdayField.text isEqualToString:@""]){
        [self showAlertViewWithErrorMessage:@"Please enter your birthday"];
    }
    else if ([nameField.text isEqualToString:@""]){
        [self showAlertViewWithErrorMessage:@"Please enter your name"];
    }
    else if (gender.selectedSegmentIndex != 0 && gender.selectedSegmentIndex != 1){
        [self showAlertViewWithErrorMessage:@"Please pick a gender"];
    }
    else{
        Create3ViewController *cv = [[Create3ViewController alloc]init];
        cv.username = self.username;
        cv.password = self.password;
        cv.email = self.email;
        cv.birthday = self.birthdayField.text;
        cv.name = nameField.text;
        cv.gender = (gender.selectedSegmentIndex == 0) ? NO : YES;
        cv.profPic = (pB.imageView.image) ? pB.imageView.image : nil;
        
        [self.navigationController pushViewController:cv animated:YES];
    }
}

/*Methods attached to the tap views to resign the keyboard*/
- (void)tapped{
    if (birthdayField.isFirstResponder) {
        [birthdayField resignFirstResponder];
    }
    if (nameField.isFirstResponder){
        [nameField resignFirstResponder];
    }
}

/*Method attached to the date picker which updates the textfield when
 the date gets updated*/
- (void)dateChanged{
    UIDatePicker *picker =  (UIDatePicker*)birthdayField.inputView;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateFormatterLongStyle;
    birthdayField.text = [df stringFromDate:picker.date];
}

//This method handles the banner animation and its text
- (void)showAlertViewWithErrorMessage:(NSString*)error{
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
        }];
    }];
}

/*Method that is attached to the picture button which displays an action sheet*/
- (void)addPhoto{
    UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:@"Add Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Picture" otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    ac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [ac showInView:self.view];
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

/*This is where the text views get attached to the table view cells*/
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        UIDatePicker *dp = [[UIDatePicker alloc]init];
        dp.datePickerMode = UIDatePickerModeDate;
        dp.backgroundColor = [UIColor whiteColor];
        [dp addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        
        cell.imageView.image = [UIImage imageNamed:@"birthday.png"];
        //creating the birthday text field and assigning a date picker as its first responder
        birthdayField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
        birthdayField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Choose your birthday" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        birthdayField.borderStyle = UITextBorderStyleNone;
        birthdayField.textColor = [UIColor whiteColor];
        birthdayField.inputView = dp;
        birthdayField.backgroundColor = [UIColor clearColor];
        birthdayField.delegate = self;
        [cell.contentView addSubview:birthdayField];
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"firstName.png"];
        //creating the name text field
        nameField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width + 1, 44)];
        nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        nameField.borderStyle = UITextBorderStyleNone;
        nameField.textColor = [UIColor whiteColor];
        nameField.backgroundColor = [UIColor clearColor];
        nameField.delegate = self;
        [cell.contentView addSubview:nameField];
    }
    if (indexPath.row == 2){
        //creating the segmented control
        gender = [[UISegmentedControl alloc]initWithFrame:CGRectMake(20, 9, self.view.frame.size.width - 40, 26)];
        [gender insertSegmentWithTitle:@"Male" atIndex:0 animated:YES];
        [gender insertSegmentWithTitle:@"Female" atIndex:0 animated:YES];
        gender.tintColor = [UIColor whiteColor];
        [cell.contentView addSubview:gender];
    }
    return cell;
}

//------------------------------------------------UITextFieldDelegate-----------------------------------------------------------

//handles when the user presses enter on the textfield
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == birthdayField){
        UIDatePicker *picker = (UIDatePicker*)textField.inputView;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateStyle = NSDateFormatterLongStyle;
        textField.text = [df stringFromDate:picker.date];
    }
    if (textField == nameField){
        [textField resignFirstResponder];
    }
}

//------------------------------------------------UIActionSheetDelegate-----------------------------------------------------------

//handles what happens when the actionsheet buttons are selected
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    switch (buttonIndex) {
        case 2:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        case 0:
            [pB setImage:nil forState:UIControlStateNormal];
            [pB setTitle:@"Photo" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//------------------------------------------------UIImagePickercontrollerDelegate-----------------------------------------------------------

//when the image picker controller is done, it will set the picture to the button
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^(void){
        [pB setImage:image forState:UIControlStateNormal];
    }];
}

@end
