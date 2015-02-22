//
//  MainViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 8/13/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "MainViewController.h"
#import "PlaceTableViewCell.h"
#import "LoginViewController.h"
#import "DHNavigationController.h"
#import "SearchPlaceCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "PlaceViewController.h"
#import "WDActivityIndicator.h"
#import "TLYShyNavBarManager.h"
#import "DCTableViewCell.h"
#import "DCRecentSearchView.h"
#import "MenuViewController.h"
#import "MarqueeLabel.h"
#import "ServicePanel.h"
#import "MYBlurIntroductionView.h"
#import <Parse/Parse.h>
#import "DCPlaceViewController.h"
#import "DCSearchViewController.h"
#import <pop/POP.h>
#import <Doppelganger/Doppelganger.h>
#import "DCPlace.h"
#import "DCLocationManager.h"
#import "DCUtility.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define isIphone6 (self.view.frame.size.height > 320)

@interface MainViewController () <UISearchBarDelegate, UIGestureRecognizerDelegate, DCLocationManagerDelegate, menuViewControllerDelegate, UISearchControllerDelegate, UIApplicationDelegate> {
    
    //ActivityIndicator in the inital load
    WDActivityIndicator *activity;
    
    //ActivityIndicator in the tableview footer
    WDActivityIndicator *activityI;
    
    //float to keep track of the last content offset of the table view
    CGFloat lastContentOffset;
    
    //the location manager which updates the user's location
    DCLocationManager *locationManager;
    
    //The search display controller and its array
    UISearchController *searchController;
    DCSearchViewController *searchResultsController;
    DCRecentSearchView *searchView;
    
    //a geopoint that keeps an address the users current location
    PFGeoPoint *currentLocation;
    
    //the label that shows in the middle of the view when no connection is reached
    UILabel *errorLabel;
    UILabel *noResultsLabel;
    
    //the segemented control that allows filtering
    UISegmentedControl *control;
    
    //a boolean value to tell if the view controller is loading first
    BOOL firstLoad;
    BOOL loadedAll;
    
    //check if cell is animating
    BOOL animating;
    
    //integer to keep some things safe
    int safeIndex;
}

//the main array that holds all of the places
@property (nonatomic, strong) NSMutableArray *placeData;

@end

static const CGFloat kCellHeight = 200;

@implementation MainViewController

@synthesize placeData, scrollDirection;

#pragma mark - Loading Methods

- (id)init{
    self = [super init];
    if (self) {
        
        [[PFInstallation currentInstallation] setBadge:0];
        
        //on first load, sets the type to both bars and night clubs
        self.type = [self typeForInt:[[NSUserDefaults standardUserDefaults]integerForKey:@"type"]];
        
        //sets the initial filter to population
        self.filter = [self filterForInt:[[NSUserDefaults standardUserDefaults]integerForKey:@"filter"]];
        
        //setting up some view things
        self.view.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
        self.title = @"";
        self.view.userInteractionEnabled = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        
        //initializing the location manager
        locationManager = [[DCLocationManager alloc]init];
        locationManager.delegate = self;
        
        //doing some tableview stuff
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //set to yes because it is the first load
        firstLoad = YES;
        
        placeData = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //creating the search controller and its array
    searchResultsController = [[DCSearchViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];
    searchController.searchResultsUpdater = searchResultsController;
    searchController.delegate = self;
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.clipsToBounds = YES;
    searchController.searchBar.placeholder = (isIphone6)?
    @"Search For Places                                     ":
    @"Search For Places                      ";
    searchController.searchBar.backgroundColor = [UIColor colorWithWhite:.15 alpha:1];
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchController.searchBar.barTintColor = [UIColor colorWithWhite:.075 alpha:1];
    searchController.searchBar.autoresizingMask = UIViewAutoresizingNone;
    searchController.searchBar.delegate = (id<UISearchBarDelegate>)searchResultsController;
    
    for (UIView *subView in searchController.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                searchBarTextField.textColor = [UIColor whiteColor];
                break;
            }
        }
    }
    
    searchResultsController.searchBar = searchController.searchBar;
    
    //creating the bar button items
    [self createBarButtonItems];
    
    //adds this current user to the current installation
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
    [currentInstallation saveEventually];
    
    //the activity indicator that shows when the table view is loading
    activity = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activity setIndicatorStyle:WDActivityIndicatorStyleGradient];
    [activity setNativeIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.hidesWhenStopped = YES;
    [self.view addSubview:activity];
    [activity startAnimating];
    
    //initializing the error label, but making it hidden until there is a connection error
    errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 80)];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.text = @"Check Your Connection";
    errorLabel.textColor = [UIColor lightTextColor];
    errorLabel.font = [UIFont systemFontOfSize:23];
    errorLabel.hidden = YES;
    [self.view addSubview:errorLabel];
    
    //segmented control that allows the user to switch between sorting via location or population
    control = [[UISegmentedControl alloc]initWithFrame:CGRectMake(5, 5,self.view.frame.size.width - 30, 30)];
    control.tintColor = [UIColor blackColor];
    [control insertSegmentWithTitle:@"Population" atIndex:0 animated:NO];
    [control insertSegmentWithTitle:@"Location" atIndex:0 animated:NO];
    [control addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];
    
    //Will display searchcontroller over this viewcontroller
    self.definesPresentationContext = YES;
    
    //adding a refresh control to the table view
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getNewLocationsForCurrentType) forControlEvents:UIControlEventValueChanged];
    
    /*check if the filter is population on first load, and if it is
     then get new types. If it isnt, then wait for location to update
     or else an exception will be thrown
     */
    
    if (self.filter == FilterPopulation) {
        [self getNewLocationsForCurrentType];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    //make the locationManager start updating the location
    [locationManager getUserLocationWithInterval:20];
    
    /* Library code */
    self.shyNavBarManager.scrollView = (UIScrollView*)self.tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //setting up the hiding navigation bar
    self.shyNavBarManager.expansionResistance = 200.0f;
    self.shyNavBarManager.contractionResistance = 60.0f;
    self.shyNavBarManager.scrollView = self.tableView;
}

#pragma mark - Data Methods

/*This method will only be called when you are getting new locations
 *This method checks all types and downloads the required data
 *Does not get called to load more data, only the initial 15
 */

- (void)getNewLocationsForCurrentType{
    //disable the search bar
    searchController.searchBar.userInteractionEnabled = NO;
    
    //create a query for places
    PFQuery *query = [DCPlace query];
    
    //check all the filters and types to adjust the query accordingly
    switch (self.type) {
        case TypeBar:
            [query whereKey:@"type" containsString:@"bar"];
            break;
        case TypeNight:
            [query whereKey:@"type" containsString:@"night_club"];
            break;
        case TypeBoth:
            break;
        default:
            break;
    }
    switch (self.filter) {
        case FilterLocation:
            if (!currentLocation) {
                break;
            }
            [query whereKey:@"location" nearGeoPoint:currentLocation];
            break;
        case FilterPopulation:
            [query orderByAscending:@"population"];
        default:
            break;
    }
    
    //limit the query to only 15 places, the rest will be downloaded if the user scrolls down
    query.limit = 15;
    
    //start the query and get the objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error){
        if (!error) {
            
            /*Store the old place data
             *Set the new data
             *Compare the old data to the new data and look for changes
                *Algorithm will create a new array containing only those differences
             *Algorithm will then update the tableview accordingly just moving the cells that have been changed
             */
            NSArray *oldData = placeData;
            placeData = [[NSMutableArray alloc]initWithArray:objs];
            [activity stopAnimating];
            NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:placeData
                                                        previousArray:oldData];
            [self.tableView wml_applyBatchChanges:diffs
                                        inSection:1
                                 withRowAnimation:UITableViewRowAnimationFade];
            
            //scroll the tableview to the top
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //reload the tableview but after the cells have animated from being changed/moved
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.25];
            if (!self.view.userInteractionEnabled) {
                self.view.userInteractionEnabled = YES;
            }
            errorLabel.hidden = YES;
            [self.refreshControl endRefreshing];
            
            searchController.searchBar.userInteractionEnabled = YES;
        }
        else{
            //there was an error getting the data so show an error label
            errorLabel.hidden = NO;
            [activity stopAnimating];
            placeData = [[NSMutableArray alloc]init];
            [self.tableView reloadData];
        }
        activityI.hidden = NO;
        firstLoad = NO;
    }];
}


/*This method is called when the table view reaches its last index path
 *It then loads more data based on the current filters
 */
- (void)loadMoreLocationsForCurrentType{
    
    //disable the search bar while loading data
    searchController.searchBar.userInteractionEnabled = NO;
    
    /*store the amount of current places
     *We do this in order to not load the currently loaded data
     */
    int currentSize = (int)placeData.count;
    
    //create the query with the current filters
    PFQuery *query = [DCPlace query];
    switch (self.type) {
        case TypeBar:
            [query whereKey:@"type" containsString:@"bar"];
            break;
        case TypeNight:
            [query whereKey:@"type" containsString:@"night_club"];
            break;
        default:
            break;
    }
    switch (self.filter) {
        case FilterLocation:
            if (!currentLocation) {
                break;
            }
            [query whereKey:@"location" nearGeoPoint:currentLocation];
            break;
        case FilterPopulation:
            [query orderByAscending:@"population"];
        default:
            break;
    }
    //limit the query to 15 places and skip the currently loaded places
    query.limit = 15;
    query.skip = currentSize;
    
    //run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //add the objects to the current places and reload the tableview
            [self addObjectsToArray:placeData fromArray:objects];
            [activityI stopAnimating];
            [self.tableView reloadData];
            searchController.searchBar.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - Helper Methods

/*helper method that is synergizes with NSUserDefaults 
 *This is done because NSUserDefaults cannot store an enum
 and in turn will store an integer
 *Botht these methods convert that integer into their respective
 enum value
 */
- (Filter)filterForInt:(NSInteger)number{
    switch (number) {
        case 1:
            return FilterLocation;
            break;
        default:
            break;
    }
    return FilterPopulation;
}

- (Type)typeForInt:(NSInteger)number{
    switch (number) {
        case 1:
            return TypeBar;
            break;
        case 2:
            return TypeNight;
            break;
        default:
            break;
    }
    return TypeBoth;
}

/*Helper method that adds objects from the downloaded array to main array
 *Makes sure that there are no duplicates in the main array
 */

- (void)addObjectsToArray:(NSMutableArray*)array fromArray:(NSArray*)array2{
    for (NSDictionary *object in array2) {
        if (![array containsObject:object]) {
            [array addObject:object];
        }
    }
}

//Method attached to the ValueChanged event of the segemented control
//Changes the NSUserDefaults value for the filter and reloads all the current data
- (void)filterChanged:(id)sender{
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            self.filter = FilterLocation;
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"filter"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        case 1:
            self.filter = FilterPopulation;
            [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"filter"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        default:
            break;
    }
    [self getNewLocationsForCurrentType];
}

#pragma mark - All Search Methods


/*What is going on with the search is that when the searchBar becomes
 the first responder, a custom search view is added to the current view
 and faded in.
 *Problematically added to the tableview requires added to the current contentoffset
 so that the view will actually be displayed no matter where you are in the scroll view
 */

- (void)willDismissSearchController:(UISearchController *)searchController{
    [self createBarButtonItems];
    [UIView animateWithDuration:.3 animations:^{
        searchView.alpha = 0;
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:searchView];
        [searchView removeFromSuperview];
    }];
    self.tableView.scrollEnabled = YES;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
\
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.navigationItem.leftBarButtonItem = nil;
    if (!searchView) {
        searchView = [[DCRecentSearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        searchView.searchBar = searchController.searchBar;
    }
    searchView.alpha = 0;
    [searchView setFrame:CGRectMake(0, lastContentOffset + 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:searchView];
    [UIView animateWithDuration:.3 animations:^{
        searchView.alpha = 1;
    }];
    self.tableView.scrollEnabled = NO;
    [searchView reloadData];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];

    
}

#pragma mark - Button Methods

//Method that opens the right drawer
//Attached to the right bar button item
- (void)menu{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

//method that is used to quickly set up the navigation bar correctly
- (void)createBarButtonItems{
    //setting the right bar item to a menu button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(menu)];
    
    self.navigationItem.titleView = searchController.searchBar;
}

#pragma mark - MenuViewControllerDelegate

//Delegate method when the right drawer controller selects a different index
- (void)menuViewControllerDidSelectButtonAtIndex:(NSInteger)index{
    if (index == 0){
        self.type = TypeBar;
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else if (index == 1){
        self.type = TypeNight;
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        self.type = TypeBoth;
        [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self getNewLocationsForCurrentType];
}

#pragma mark - CLLocationManagerDelegate

/*Location manager delegate method
 *Used to find the closest place to the user
 *There are two possibilities
 1. The user is already in a place and the method will check to see
 if the user has left the place they are in
 2. The user is not in a place and the method will check to see if the
 user has entered a place
 *If either of these are true then it will send a notification to the user
 asking them to either check in or check out or cancel if they haven't done either
 */

- (void)DCLocationManagerDidUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = [locations lastObject];
    
    NSLog(@"Veritcal Accuracy: %f", lastLocation.verticalAccuracy);
    NSLog(@"Horizontal Accuracy: %f", lastLocation.horizontalAccuracy);
    
    if (lastLocation.horizontalAccuracy > 100 || lastLocation.verticalAccuracy > 100) {
        return;
    }
    currentLocation = [PFGeoPoint geoPointWithLocation:lastLocation];
    NSLog(@"Updated Location to %@", currentLocation);
    if (firstLoad && self.filter == FilterLocation) {
        [self getNewLocationsForCurrentType];
        firstLoad = NO;
    }
    [self handleLocationUpdate];
}

- (void)DCLocationManagerDidFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HasAllowedLocation"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
            [[PFUser currentUser] deleteEventually];
        }
        [PFUser logOut];
        
        LoginViewController *lv = [[LoginViewController alloc]init];
        
        DHNavigationController *nav = [[DHNavigationController alloc]initWithRootViewController:lv];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.barTintColor = [UIColor clearColor];
        nav.navigationBarHidden = NO;
        nav.navigationBar.barStyle = UIBarStyleBlack;
        
        [self.mm_drawerController setRightDrawerViewController:nil];
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
}

- (void)handleLocationUpdate{
    /*Create a query to get the closest place to the user*/
    PFQuery *query = [DCPlace query];
    [query whereKey:@"location" nearGeoPoint:currentLocation];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            DCPlace *closestPlace = (DCPlace*)object;
            
            /*Use NSUserDefaults to keep track of whether the phone is in a place or not*/
            if (![[NSUserDefaults standardUserDefaults]objectForKey:@"isInPlace"]) {
                [[NSUserDefaults standardUserDefaults]setObject:@"N/A" forKey:@"isInPlace"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            /*Now we have the closest place
             *Check to see if the phones current location is within 10 meters of the place
             *Also check to make sure the user wont recieve more than one notification*/
            CGFloat metersToNearestPlace = [currentLocation distanceInKilometersTo:closestPlace.location]*1000;
            NSString *currentPlaceString = [[NSUserDefaults standardUserDefaults]objectForKey:@"isInPlace"];
            NSLog(@"%f", metersToNearestPlace);
            NSLog(@"%@", currentPlaceString);
            if (metersToNearestPlace <= 10.0 && [currentPlaceString isEqualToString:@"N/A"]) {
                /*User is in the place, so send notification and handle entering*/
                [[NSUserDefaults standardUserDefaults]setObject:closestPlace.name forKey:@"isInPlace"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                /*Get the correct settings*/
                [DCUtility registerNotificationSetttingsForEntering];
                
                /*Create the actual local notification and send it*/
                [DCUtility pushLocalNotificationWithMessage:[NSString stringWithFormat:@"You have arrived at %@", closestPlace.name] placeName:closestPlace.name];
                
                /*Add user to the place*/
                [DCUtility user:[PFUser currentUser] shouldEnterPlace:closestPlace];
                
                return;
            }
            else if (metersToNearestPlace > 10.0 && ![currentPlaceString isEqualToString:@"N/A"]){
                /*User isnt in the place
                 *If user was previously in the place ask them to leave */
                [[NSUserDefaults standardUserDefaults]setObject:@"N/A" forKey:@"isInPlace"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                /*Get the correct settings*/
                [DCUtility registerNotificationSetttingsForLeaving];
                
                /*Create the local notification and send it*/
                [DCUtility pushLocalNotificationWithMessage:[NSString stringWithFormat:@"You have left %@", closestPlace.name] placeName:closestPlace.name];
                
                /*Remove user from the place*/
                [DCUtility user:[PFUser currentUser] shouldLeavePlace:closestPlace];
                
                return;
            }
        }
        else{
            /*Handle the error*/
            NSLog(@"Unable to find place");
            return;
        }
    }];
    
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 1) ? placeData.count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return (indexPath.section == 2) ? 40 : kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.backgroundColor = [UIColor clearColor];
        
        if (placeData.count >= 15) {
            activityI = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 10, 10, 20, 20)];
            activityI.indicatorStyle = WDActivityIndicatorStyleGradient;
            [activityI setNativeIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityI.hidesWhenStopped = YES;
            
            [cell1.contentView addSubview:activityI];
        }
        
        return cell1;
    }
    else if (indexPath.section == 1){
        DCTableViewCell *cell;
        if (ABS(indexPath.row - safeIndex) <= 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:nil];
            if (!cell) {
                cell = [[DCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[DCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
        }
        DCPlace *place = placeData[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.placeImageView.image = nil;
        cell.placeImageView.file = place.placeImage;
        [cell.placeImageView loadInBackground:^(UIImage *image, NSError *error){
        }];
        
        cell.nameLabel.text = place.name;
        [cell.nameLabel sizeToFit];
        CGRect frame = cell.nameLabel.frame;
        frame.size.width = MIN(cell.placeImageView.frame.size.width-20, frame.size.width+10);
        [cell.nameLabel setFrame:frame];
        
        if ([place.population intValue] == 1) {
            cell.populationLabel.text = [NSString stringWithFormat:@"1 Person"];
        }
        else{
            cell.populationLabel.text = [NSString stringWithFormat:@"%i People", [place.population intValue]];
        }
        
        float distanceTo = [currentLocation distanceInMilesTo:place.location];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles",distanceTo];
        CGFloat maxRight = cell.placeImageView.frame.size.width + cell.placeImageView.frame.origin.x;
        [cell.distanceLabel sizeToFit];
        CGRect frame2 = cell.distanceLabel.frame;
        if (frame2.size.width + frame2.origin.x > maxRight) {
            frame2.origin.x -= frame2.size.width + frame2.origin.x - maxRight;
            [cell.distanceLabel setFrame:frame2];
        }
        
        cell.typeLabel.hidden = (self.type != TypeBoth);
        
        if (!cell.typeLabel.hidden) {
            cell.typeLabel.text = ([place.type isEqualToString:@"bar"])?@"Bar":@"Night Club";
        }
        
        return cell;
        
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3;
        view.layer.shadowRadius = 1.5f;
        view.layer.shadowOpacity = 1;
        view.layer.shadowOffset = CGSizeMake(0, 3);
        [cell.contentView addSubview:view];
    
        [view addSubview:control];
        
        if (![[NSUserDefaults standardUserDefaults]integerForKey:@"filter"]){
            control.selectedSegmentIndex = 1;
        }
        else{
            control.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"filter"] - 1;
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return;
    }
    DCPlace *tempPlace = placeData[indexPath.row];
    if ([tempPlace.name isEqualToString:((DCPlaceViewController*)self.mm_drawerController.rightDrawerViewController).place.name]){
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        return;
    }
    DCPlaceViewController *pv = [[DCPlaceViewController alloc]initWithPlace:tempPlace.name];
    [self.mm_drawerController setRightDrawerViewController:pv];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (scrollDirection == ScrollDirectionDown && indexPath.row > self.view.frame.size.height / kCellHeight)
    {
        static NSUInteger xOffset = 30;
        static NSUInteger yOffset = 60;
        
        cell.frame = CGRectMake(cell.frame.origin.x - xOffset, cell.frame.origin.y + yOffset, cell.frame.size.width, cell.frame.size.height);
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(cell.frame.origin.x + xOffset, cell.frame.origin.y - yOffset, cell.frame.size.width, cell.frame.size.height)];
        anim.springSpeed = 8;
        anim.springBounciness = 10;
        [cell pop_addAnimation:anim forKey:@"grow"];
        
        safeIndex = (int)indexPath.row;
    }
    
    if (indexPath.section == 2) {
        [self loadMoreLocationsForCurrentType];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat delta = scrollView.contentOffset.y;
    
    if (lastContentOffset > delta) {
        scrollDirection = ScrollDirectionUp;
    }
    if (lastContentOffset < delta) {
        scrollDirection = ScrollDirectionDown;
    }
    
    lastContentOffset = delta;
    
    if (delta < 0) {
        CGRect rect = self.refreshControl.frame;
        rect.origin.y += delta/4;
        [self.refreshControl setFrame:rect];
    }
}

@end
