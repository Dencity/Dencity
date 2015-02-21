//
//  DCRecentSearchView.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/30/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCRecentSearchView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *recentSearchArray;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
