//
//  DCSearchViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/22/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCSearchViewController.h"
#import <Parse/Parse.h>
#import "WDActivityIndicator.h"
#import <pop/POP.h>
#import "SearchPlaceCell.h"
#import "DCPlaceViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FXBlurView.h"
#import "DCPlace.h"

@interface DCSearchViewController ()<UISearchBarDelegate>{
    BOOL loadedAll;
    UILabel *noResultsLabel;
}

@end

@implementation DCSearchViewController

#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
        _internalArray = [[NSMutableArray alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    noResultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 30 - 44, self.view.frame.size.width, 60)];
    noResultsLabel.textColor = [UIColor grayColor];
    noResultsLabel.text = @"No Results";
    noResultsLabel.font = [UIFont systemFontOfSize:40];
    noResultsLabel.textAlignment = NSTextAlignmentCenter;
    noResultsLabel.hidden = YES;
    [self.view addSubview:noResultsLabel];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_internalArray removeAllObjects];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.tableView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
}

#pragma mark - TableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _internalArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!loadedAll && _internalArray.count == 10) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 5.0f;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"Load All Results" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadAll:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected");
    DCPlace *tempPlace = _internalArray[indexPath.row];
    DCPlaceViewController *pv = [[DCPlaceViewController alloc]initWithPlace:tempPlace.name];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (!cell) {
        cell = [[SearchPlaceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    DCPlace *place = _internalArray[indexPath.row];
    
    cell.nameLabel.text = place.name;
    cell.placeImage.image = nil;
    cell.placeImage.file = place.placeImage;
    [cell.placeImage loadInBackground:^(UIImage *image, NSError *error){
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchPlaceCell *cell1 = (SearchPlaceCell*)cell;
    CGRect to = CGRectMake(10, 10, 40, 40);
    CGRect from = CGRectMake(20, 20, 20, 20);
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue = [NSValue valueWithCGRect:from];
    anim.toValue = [NSValue valueWithCGRect:to];
    anim.springBounciness = 15;
    anim.springSpeed = 8;
    [cell1.placeImage pop_addAnimation:anim forKey:@"grow"];
}

#pragma mark - Search Methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    UISearchBar *tempBar = searchController.searchBar;
    [self updateInteralArrayForSearchText:tempBar.text];
    loadedAll = NO;
}

- (void)updateInteralArrayForSearchText:(NSString*)searchText{
    PFQuery *query = [DCPlace query];
    [query whereKey:@"name" containsString:searchText];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_internalArray removeAllObjects];
            if (objects.count == 1) {
                loadedAll = YES;
            }
            [self addObjectsToArray:_internalArray fromArray:objects];
            [self.tableView reloadData];
            if (_internalArray.count == 0) {
                noResultsLabel.hidden = NO;
                self.tableView.scrollEnabled = NO;
            }
            else{
                noResultsLabel.hidden = YES;
                self.tableView.scrollEnabled = YES;
            }
        }
    }];
}

- (void)loadAll:(id)sender{
    UIButton *button = (UIButton*)sender;
    [button setTitle:@"Loading All Results" forState:UIControlStateNormal];
    WDActivityIndicator *indicator = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(button.frame.size.width - 40, (button.frame.size.height - 20) / 2, 20, 20)];
    indicator.hidesWhenStopped = YES;
    indicator.indicatorStyle = WDActivityIndicatorStyleSegment;
    indicator.nativeIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [button addSubview:indicator];
    PFQuery *query = [DCPlace query];
    [query whereKey:@"name" containsString:_searchBar.text];
    query.skip = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_internalArray addObjectsFromArray:objects];
            [self.tableView reloadData];
            [indicator stopAnimating];
        }
    }];
    loadedAll = YES;
}

#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSMutableArray *searchArray;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"recentSearches"]) {
        searchArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:searchArray forKey:@"recentSearches"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        searchArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]arrayForKey:@"recentSearches"]];
    }
    [searchArray insertObject:searchBar.text atIndex:0];
    if (searchArray.count > 10) {
        [searchArray removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults]setObject:searchArray forKey:@"recentSearches"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reload" object:nil];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark - Helper Method

- (void)addObjectsToArray:(NSMutableArray*)array fromArray:(NSArray*)array2{
    for (NSDictionary *object in array2) {
        if (![array containsObject:object]) {
            [array addObject:object];
        }
    }
}

@end
