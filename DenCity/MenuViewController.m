//
//  MenuViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 8/19/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "DHNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "ProfileViewController.h"
#import "DCMenuTableViewCell.h"
#import "AppDelegate.h"

#define width(x) ([UIScreen mainScreen].bounds.size.width - 280) - x
#define angle(x) ((x)/180*M_PI)

@interface MenuViewController (){
    NSArray *imageArray;
    NSArray *sImageArray;
}

@end

@implementation MenuViewController

@synthesize tableView;

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithWhite:.075 alpha:1];
        imageArray = @[[UIImage imageNamed:@"menu_Bar_White"],[UIImage imageNamed:@"menu_Nightclub_White"],[UIImage imageNamed:@"menu_Bar_White"],[UIImage imageNamed:@"menu_Profile_White"],[UIImage imageNamed:@"menu_Settings_White"], [UIImage imageNamed:@"menu_Logout_White"]];
        sImageArray = @[[UIImage imageNamed:@"menu_Bar_Black"],[UIImage imageNamed:@"menu_Nightclub_Black"],[UIImage imageNamed:@"menu_Bar_Black"],[UIImage imageNamed:@"menu_Profile_Black"],[UIImage imageNamed:@"menu_Settings_Black"], [UIImage imageNamed:@"menu_Logout_Black"]];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"type"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else{
        NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:@"type"] - 1;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width(0), self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageArray.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width(0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    
    DCMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DCMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, .5, cell.frame.size.width + 5, .5)];
        separator.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:separator];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.normalImage = imageArray[indexPath.row];
    cell.selectedImage = sImageArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 2) {
        [self.delegate menuViewControllerDidSelectButtonAtIndex:indexPath.row];
    }
    if (indexPath.row == 3) {
        //show the profile
    }
    if (indexPath.row == 4) {
        //show the settings
    }
    if (indexPath.row == 5) {
        [self logOut];
    }
}

#pragma mark - Selection Methods

- (void)logOut{
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [[PFUser currentUser] deleteEventually];
    }
    [PFUser logOut];
    
    LoginViewController *lv = [[LoginViewController alloc]init];
    
    DHNavigationController *nav = [[DHNavigationController alloc]initWithRootViewController:lv];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
    nav.navigationBar.translucent = YES;
    nav.view.backgroundColor = [UIColor clearColor];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    

    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    [self.mm_drawerController setRightDrawerViewController:nil];
    [self.mm_drawerController setLeftDrawerViewController:nil];
}

@end
