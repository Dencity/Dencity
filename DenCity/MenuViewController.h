//
//  MenuViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 8/19/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol menuViewControllerDelegate <NSObject>

- (void)menuViewControllerDidSelectButtonAtIndex:(NSInteger)index;

@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<menuViewControllerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void)setDelegate:(id<menuViewControllerDelegate>)delegate;

@end


