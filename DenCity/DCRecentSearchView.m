//
//  DCRecentSearchView.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/30/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCRecentSearchView.h"

@implementation DCRecentSearchView

#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = [UIColor whiteColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:@"reload" object:nil];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"recentSearches"]) {
        _recentSearchArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:_recentSearchArray forKey:@"recentSearches"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        _recentSearchArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"recentSearches"]];
    }
    [self reloadData];
    NSLog(@"moved to superview");
}

#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*Return the interal arrays count*/
    NSLog(@"%i",(int)_recentSearchArray.count);
    return _recentSearchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Recent Searches";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = _recentSearchArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _searchBar.text = _recentSearchArray[indexPath.row];
    [self reloadData];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - Class Methods

- (void)reload{
    NSLog(@"Reloaded");
    _recentSearchArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"recentSearches"]];
    [self reloadData];
}


@end
