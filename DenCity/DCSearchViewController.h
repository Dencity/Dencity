//
//  DCSearchViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/22/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSearchViewController : UITableViewController <UISearchResultsUpdating, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *internalArray;

@end
