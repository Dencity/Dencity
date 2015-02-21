//
//  DCPlaceViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 1/19/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FXBlurView.h"
#import "DCUtility.h"
#import "WDActivityIndicator.h"
#import "DCPopulationPlaceCell.h"
#import "PersonTableViewCell.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DCPlaceViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate,  DCPopulationPlaceCellDelegate>{
    UIImage *currentImage;
    
    WDActivityIndicator *ind;
    
    DCPopulationPlaceCell *populationView;
    UITableView *peopleView;
    
    UIView *headerView;
    UIView *bottomView;
    
    CGFloat topOrigin;
    
    NSMutableArray *people;
    UILabel *noPeopleLabel;
    
    CGRect originalPeopleFrame;
    CGRect toPeopleFrame;
}

@end

const CGFloat header_height = 70;

@implementation DCPlaceViewController

@synthesize nonBlurBackgroundImageView, backgroundImageView;

#pragma mark - Life Cycle

- (id)initWithPlace:(NSString *)place{
    self = [super init];
    if (self) {
        [self placeFromString:place];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpViews];
}


#pragma mark - Startup Methods

- (void)placeFromString:(NSString*)string{
    
    ind = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    ind.center = self.view.center;
    ind.hidesWhenStopped = YES;
    ind.indicatorStyle = WDActivityIndicatorStyleGradient;
    ind.nativeIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:ind];
    [ind startAnimating];
    
    PFQuery *query = [DCPlace query];
    [query whereKey:@"name" equalTo:string];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.place = (DCPlace*)object;
            [self loadData];
        }
    }];
}

- (void)loadData{
    PFFile *file = self.place.placeImage;
    if (file == nil) {
        [ind stopAnimating];
    }
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [backgroundImageView setFrame:[self frameForSize:image.size]];
            backgroundImageView.image = [image blurredImageWithRadius:40 iterations:15 tintColor:[UIColor clearColor]];
            [nonBlurBackgroundImageView setFrame:backgroundImageView.frame];
            nonBlurBackgroundImageView.image = image;
            currentImage = image;
            [ind stopAnimating];
        }
    }];
    
    placeNameLabel.text = self.place.name;
    [placeNameLabel sizeToFit];
    [placeNameLabel setFrame:CGRectMake(10, 15, MIN(self.view.frame.size.width-20, placeNameLabel.frame.size.width + 4), placeNameLabel.frame.size.height)];
    
    people = [NSMutableArray arrayWithArray:self.place.people];
    [peopleView reloadData];
    
    if (people.count == 0) {
        noPeopleLabel.alpha = 1;
    }
    
    placeAddressLabel.text = self.place.address;
    [placeAddressLabel sizeToFit];
    [placeAddressLabel setFrame:CGRectMake(10, 40, placeAddressLabel.frame.size.width + 4, placeAddressLabel.frame.size.height)];
    
    populationView.popLabel.text = [NSString stringWithFormat:@"Current Population: %i", [self.place.population intValue]];
    populationView.oldPopLabel.text = [NSString stringWithFormat:@"Population Yesterday: %i", [self.place.oldPopulation intValue]];
    
    [UIView animateWithDuration:.5 animations:^{
        populationView.alpha = 1;
        backButton.alpha = 1;
        peopleView.alpha = 1;
    }];
}

- (void)setUpViews{
    
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    //normal setup
    backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.backgroundColor = [UIColor grayColor];
    nonBlurBackgroundImageView = [[UIImageView alloc]init];
    nonBlurBackgroundImageView.alpha = 0;
    [self.view addSubview:backgroundImageView];
    [self.view addSubview:nonBlurBackgroundImageView];
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, header_height, self.view.frame.size.width, self.view.frame.size.height-header_height-50)];
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(0, 1000);
    mainScrollView.scrollEnabled = YES;
    [self.view addSubview:mainScrollView];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, header_height)];
    topOrigin = headerView.frame.origin.y;
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    CGRect rect  = CGRectMake(10, 15, 0, 0);
    placeNameLabel = [[MarqueeLabel alloc]initWithFrame:rect];
    placeNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    placeNameLabel.textColor = [UIColor whiteColor];
    placeNameLabel.font = [UIFont systemFontOfSize:20];
    placeNameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:placeNameLabel];
    
    CGRect rect1 = CGRectMake(10, 40, 0, 0);
    placeAddressLabel = [[UILabel alloc]initWithFrame:rect1];
    placeAddressLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    placeAddressLabel.textColor = [UIColor lightGrayColor];
    placeAddressLabel.font = [UIFont systemFontOfSize:15];
    placeAddressLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:placeAddressLabel];
    
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:.5]] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = 7.0f;
    backButton.layer.masksToBounds = YES;
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.borderWidth = 1;
    backButton.alpha = 0;
    [bottomView addSubview:backButton];
    
    populationView = [[DCPopulationPlaceCell alloc]initWithFrame:CGRectMake(10, 10, mainScrollView.frame.size.width-20, 50)];
    populationView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
    populationView.layer.cornerRadius = 5.0f;
    populationView.layer.borderWidth = .5;
    populationView.layer.borderColor = [UIColor whiteColor].CGColor;
    populationView.alpha = 0;
    populationView.delegate = self;
    [mainScrollView addSubview:populationView];
    
    peopleView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10+populationView.frame.size.height + 10, mainScrollView.frame.size.width-20, 250) style:UITableViewStyleGrouped];
    peopleView.contentInset = UIEdgeInsetsMake(-35, 0, -35, 0);
    peopleView.separatorColor = [UIColor whiteColor];
    peopleView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
    peopleView.layer.cornerRadius = 5.0f;
    peopleView.layer.borderWidth = .5;
    peopleView.showsVerticalScrollIndicator = NO;
    peopleView.layer.borderColor = [UIColor whiteColor].CGColor;
    peopleView.alpha = 0;
    peopleView.delegate = self;
    peopleView.dataSource = self;
    
    originalPeopleFrame = peopleView.frame;
    toPeopleFrame = CGRectMake(originalPeopleFrame.origin.x, originalPeopleFrame.origin.y+150, originalPeopleFrame.size.width, originalPeopleFrame.size.height);
    
    noPeopleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    noPeopleLabel.text = @"No People";
    noPeopleLabel.textColor = [UIColor whiteColor];
    noPeopleLabel.font = [UIFont systemFontOfSize:30];
    noPeopleLabel.alpha = 0;
    [noPeopleLabel sizeToFit];
    noPeopleLabel.center = CGPointMake(peopleView.frame.size.width/2, peopleView.frame.size.height/2+10);
    [peopleView addSubview:noPeopleLabel];
    
    [mainScrollView addSubview:peopleView];
    
    [self.view bringSubviewToFront:bottomView];
}

#pragma mark - Helper Methods

- (CGRect)frameForSize:(CGSize)size{
    CGFloat oldwidth = size.width;
    CGFloat oldheight = size.height;
    if (oldwidth > self.view.frame.size.width) {
        CGFloat width = self.view.frame.size.width + 100;
        CGFloat height = (oldheight * width)/oldwidth;
        if (height < self.view.frame.size.height) {
            height = self.view.frame.size.height;
            return CGRectMake(-50, 0, width, height);
        }
        CGFloat newHeight = (height > self.view.frame.size.height) ? (height - self.view.frame.size.height)/2 : 0;
        return CGRectMake(-50, -newHeight, width, height);
    }
    if (oldheight > self.view.frame.size.width) {
        CGFloat height = self.view.frame.size.height + 100;
        CGFloat width = (oldwidth * height)/oldheight;
        if (width < self.view.frame.size.width) {
            width = self.view.frame.size.width;
            return CGRectMake(0, -50, width, height);
        }
        CGFloat newWidth = (width > self.view.frame.size.width) ? (width - self.view.frame.size.width)/2 : 0;
        return CGRectMake(-newWidth, -50, width, height);
    }
    if (oldwidth < self.view.frame.size.width) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = (oldheight *width)/oldwidth;
        if (height < self.view.frame.size.height) {
            height = self.view.frame.size.height;
            return CGRectMake(0, 0, width, height);
        }
        CGFloat newHeight = (height > self.view.frame.size.height) ? (height - self.view.frame.size.height)/2 : 0;
        return CGRectMake(0, -newHeight, width, height);
    }
    if (oldheight < self.view.frame.size.height) {
        CGFloat height = self.view.frame.size.height;
        CGFloat width = (oldwidth * height)/oldheight;
        if (width < self.view.frame.size.width) {
            width = self.view.frame.size.width;
            return CGRectMake(0, 0, width, height);
        }
        CGFloat newWidth = (width > self.view.frame.size.width) ? (width - self.view.frame.size.width)/2 : 0;
        return CGRectMake(-newWidth, 0, width, height);
    }
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Button Methods

- (void)back{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - DCPopulationPlaceCellDelegate

- (void)buttonWasPressed:(BOOL)selected{
    if (selected){
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect rect = populationView.frame;
        rect.size.height = 200;
        anim.toValue = [NSValue valueWithCGRect:rect];
        anim.springBounciness = 5;
        anim.springSpeed = 3;
        [populationView pop_addAnimation:anim forKey:@"grow"];
        
        POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect rect1 = peopleView.frame;
        rect1.origin.y += 150;
        anim1.toValue = [NSValue valueWithCGRect:toPeopleFrame];
        anim1.springBounciness = 10;
        anim1.springSpeed = 5;
        [peopleView pop_addAnimation:anim1 forKey:@"moveDown"];
    }
    else{
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect rect = populationView.frame;
        rect.size.height = 50;
        anim.toValue = [NSValue valueWithCGRect:rect];
        [populationView pop_addAnimation:anim forKey:@"shrink"];

        POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect rect1 = peopleView.frame;
        rect1.origin.y -= 150;
        anim1.toValue = [NSValue valueWithCGRect:originalPeopleFrame];
        anim1.springBounciness = 5;
        anim1.springSpeed = 3; 
        [peopleView pop_addAnimation:anim1 forKey:@"moveUp"];
    }
}

#pragma mark - DCPeoplePlaceCellDelegate and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == peopleView) {
        return 50;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == peopleView) {
        return people.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"creating cell");
    if (tableView == peopleView) {
        PersonTableViewCell *cell;
        PFQuery *query = [PFUser query];;
        [query whereKey:@"objectId" equalTo:people[indexPath.row]];
        PFUser *user = (PFUser*)[query getFirstObject];
        NSLog(@"User is %@", user);
        if ([PFAnonymousUtils isLinkedWithUser:user]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellAnonymous"];
            //set up for anonymous user
            if (!cell) {
                cell = [[PersonTableViewCell alloc]initWithType:PersonTableViewCellTypeAnonymous reuseIdentifier:@"cellAnonymous" width:peopleView.frame.size.width];
            }
            cell.nameLabel.text = @"Anonymous User";
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellUser"];
            if (!cell) {
                cell = [[PersonTableViewCell alloc]initWithType:PersonTableViewCellTypePerson reuseIdentifier:@"cellUser" width:peopleView.frame.size.width];
            }
            cell.nameLabel.text = user[@"name"];
            cell.profPic.file = user[@"ProfPic"];
            cell.profPic.image = nil;
            [cell.profPic loadInBackground];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
        cell.layoutMargins = UIEdgeInsetsZero;
        
        return cell;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = scrollView.contentOffset.y;
    
    if (delta < 0) {
        nonBlurBackgroundImageView.alpha = MIN(1, -delta/300);
        populationView.alpha = 1 + delta/100;
        peopleView.alpha = 1 + delta/100;
    }
    else{
        nonBlurBackgroundImageView.alpha = 0;
        populationView.alpha = 1;
        peopleView.alpha = 1;
    }
}

#pragma mark - Data Methods

- (void)foundPerson{
}

@end
