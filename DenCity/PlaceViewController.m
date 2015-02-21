//
//  PlaceViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 9/28/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "PlaceViewController.h"
#import "WDActivityIndicator.h"
#import "PersonTableViewCell.h"
#import "ProfileViewController.h"
#import "MarqueeLabel.h"
#import "UIViewController+MMDrawerController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PlaceViewController () <UITableViewDataSource, UITableViewDelegate>{
    UIButton *back;
    WDActivityIndicator *progress;
    NSString *placeString;
    MarqueeLabel *label;
    NSTimer *timer;
    
    UIView *populationTile;
    UIView *populationTile2;
    UIView *peopleTile;
    UIView *mapTile;
    UIView *typeTile;
}

@end

@implementation PlaceViewController

- (id)initWithPlace:(NSString*)place{
    self = [super init];
    if (self) {
        placeString = place;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPlaceData];
    [self setUpScrollTiles];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, [self headerHeight])];
    [button addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self addHeaderOverlayView:button];
    
    back = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 40, 40)];
    [back setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addHeaderOverlayView:back];
    
    self.scrollView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    self.scrollView.contentSize = CGSizeMake(320, 500);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self performSelector:@selector(placeDidUpdate) withObject:nil afterDelay:30];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 915);
    [self.mainScrollView setContentSize:newSize];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(placeDidUpdate) object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y > 0 && label) {
        CGFloat newAlpha = (200-scrollView.contentOffset.y)/220;
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:newAlpha];
    }
}

- (void)scrollToTop{
    [self.mainScrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpScrollTiles{
    
    populationTile = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 70)];
    populationTile.backgroundColor = [UIColor whiteColor];
    populationTile.layer.cornerRadius = 3.0f;
    populationTile.clipsToBounds = NO;
    
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, populationTile.frame.size.width - 80, 30)];
    pLabel.text = @"Current Population";
    pLabel.font = [UIFont systemFontOfSize:25];
    pLabel.textAlignment = NSTextAlignmentCenter;
    [populationTile addSubview:pLabel];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(pLabel.frame.size.width, 10, 1, 50)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [populationTile addSubview:lineView];
    
    UILabel *iLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.frame.origin.x,20, 80, 30)];
    iLabel.textAlignment = NSTextAlignmentCenter;
    iLabel.text = [NSString stringWithFormat:@"%i", (int)self.place[@"population"]];
    iLabel.font = [UIFont systemFontOfSize:25];
    [populationTile addSubview:iLabel];

    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, populationTile.frame.size.width - 10, populationTile.frame.size.height - 10)];
    borderView.backgroundColor = [UIColor clearColor];
    borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    borderView.layer.borderWidth = .7f;
    borderView.layer.cornerRadius = 3.0f;
    [populationTile addSubview:borderView];
    
    [self.scrollView addSubview:populationTile];
    
    populationTile2 = [[UIView alloc]initWithFrame:CGRectMake(10, 90, self.view.frame.size.width - 20, 70)];
    populationTile2.backgroundColor = [UIColor whiteColor];
    populationTile2.layer.cornerRadius = 3.0f;
    populationTile2.clipsToBounds = NO;
    
    UILabel *pLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, populationTile.frame.size.width - 80, 30)];
    pLabel2.text = @"Yesterday Population";
    pLabel2.font = [UIFont systemFontOfSize:25];
    pLabel2.textAlignment = NSTextAlignmentCenter;
    [populationTile2 addSubview:pLabel2];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(pLabel2.frame.size.width, 10, 1, 50)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [populationTile2 addSubview:lineView2];
    
    UILabel *iLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(lineView2.frame.origin.x,20, 80, 30)];
    iLabel2.textAlignment = NSTextAlignmentCenter;
    iLabel2.text = [NSString stringWithFormat:@"%i", (int)self.place[@"oldPopulation"]];
    iLabel2.font = [UIFont systemFontOfSize:25];
    [populationTile2 addSubview:iLabel2];
    
    UIView *borderView2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, populationTile2.frame.size.width - 10, populationTile2.frame.size.height - 10)];
    borderView2.backgroundColor = [UIColor clearColor];
    borderView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    borderView2.layer.borderWidth = .7f;
    borderView2.layer.cornerRadius = 3.0f;
    [populationTile2 addSubview:borderView2];
    [self.scrollView addSubview:populationTile2];
    
    peopleTile = [[UIView alloc]initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 20, 360)];
    peopleTile.backgroundColor = [UIColor whiteColor];
    peopleTile.layer.cornerRadius = 3.0f;
    NSInteger count = [self.place[@"people"] count];
    if (count == 0){
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, peopleTile.frame.size.width, 40)];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"No People"];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:30];
        [peopleTile addSubview:lbl];
        
        UIView *borderView3 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, peopleTile.frame.size.width - 10, peopleTile.frame.size.height - 10)];
        
        borderView3.backgroundColor = [UIColor clearColor];
        borderView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        borderView3.layer.borderWidth = .7f;
        borderView3.layer.cornerRadius = 3.0f;
        
        [peopleTile addSubview:borderView3];
    }
    else{
        UITableView *tV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, peopleTile.frame.size.width - 10, peopleTile.frame.size.height - 10) style:UITableViewStyleGrouped];
        tV.delegate = self;
        tV.dataSource = self;
        tV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tV.layer.borderWidth = .7f;
        [peopleTile addSubview:tV];
    }
    [self.scrollView addSubview:peopleTile];
    
}

- (void)placeDidUpdate{
    [PFCloud callFunctionInBackground:@"getPopsAndPeople" withParameters:@{@"name": self.place[@"name"]} block:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"%@",object[@"population"]);
            NSLog(@"%@",object[@"people"]);
            NSLog(@"%@",object[@"oldPopulation"]);
            
            if ([object[@"people"] count] > 0){
                self.place[@"people"] = object[@"people"];
            }
            self.place[@"population"] = object[@"population"];
            self.place[@"oldPopulation"] = object[@"oldPopulation"];
            
            for (UIView *view in populationTile.subviews) {
                if (view.frame.size.width == 80) {
                    UILabel *temp = (UILabel*)view;
                    temp.text = [NSString stringWithFormat:@"%i", (int)self.place[@"population"]];
                    break;
                }
            }
            
            for (UIView *view in populationTile2.subviews) {
                if (view.frame.size.width == 80) {
                    UILabel *temp = (UILabel*)view;
                    temp.text = [NSString stringWithFormat:@"%i", (int)self.place[@"oldPopulation"]];
                    break;
                }
            }
            
            UIView *view = peopleTile.subviews[0];
            if ([view conformsToProtocol:@protocol(UITableViewDelegate)]) {
                [(UITableView*)view reloadData];
            }
            
            [self performSelector:@selector(placeDidUpdate) withObject:nil afterDelay:30];
        }
    }];
}

- (void)loadPlaceData{
    progress = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, [self headerHeight]/2 - 20, 40, 40)];
    [progress setIndicatorStyle:WDActivityIndicatorStyleGradient];
    [progress setNativeIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    progress.hidesWhenStopped = YES;
    [self.view addSubview:progress];
    [progress startAnimating];
    
    self.titleLabel.alpha = 0;
    self.subtitleLabel.alpha = 0;
    
    PFQuery *q = [PFQuery queryWithClassName:@"Place"];
    [q whereKey:@"name" equalTo:placeString];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.place = object;
        if (self.place[@"image"]) {
            PFFile *placePhoto = self.place[@"image"];
            [placePhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [self setHeaderImage:[UIImage imageWithData:data]];
                }
                [progress stopAnimating];
                [UIView animateWithDuration:.5 animations:^{
                    self.titleLabel.alpha = 1;
                    self.subtitleLabel.alpha = 1;

                }];
            }];
        }
        else{
            [progress stopAnimating];
            self.titleLabel.alpha = 1;
            self.subtitleLabel.alpha = 1;
        }
        [self setTitleText:self.place[@"name"]];
        [self setSubtitleText:self.place[@"address"]];
        
        [self.titleLabel sizeToFit];
        [self.subtitleLabel sizeToFit];
        if (self.titleLabel.frame.size.width > self.view.frame.size.width - 15) {
            [self.titleLabel removeFromSuperview];
            
            CGRect frame = self.titleLabel.frame;
            label = [[MarqueeLabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, self.view.frame.size.width - 30, frame.size.height) duration:4 andFadeLength:10];
            label.rate = 4.0f;
            label.scrollDuration = 4;
            label.text = self.titleLabel.text;
            label.backgroundColor = self.titleLabel.backgroundColor;
            label.animationDelay = 0;
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont boldSystemFontOfSize:20]];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
            [self addHeaderOverlayView:label];
        }
    }];
}

#pragma mark - UITableViewDelegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.place[@"people"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([PFAnonymousUtils isLinkedWithUser:self.place[@"people"][indexPath.row]]) {
        return;
    }
    else{
        [self.navigationController pushViewController:[[ProfileViewController alloc]initWithPerson:self.place[@"people"][indexPath.row]] animated:YES];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArray = self.place[@"people"];
    PFUser *tempUser = tempArray[indexPath.row];
    PersonTableViewCell *cell = (PersonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        if ([PFAnonymousUtils isLinkedWithUser:tempUser]) {
            cell = [[PersonTableViewCell alloc]initWithType:PersonTableViewCellTypeAnonymous reuseIdentifier:@"cell" width:self.view.frame.size.width];
            cell.nameLabel.text = @"Anonymous User";
            return cell;
        }
        else{
            cell = [[PersonTableViewCell alloc]initWithType:PersonTableViewCellTypePerson reuseIdentifier:@"cell" width:self.view.frame.size.width];
        }
    }
    
    cell.nameLabel.text = tempUser[@"name"];
        
    WDActivityIndicator *av = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(cell.profPic.frame.size.width/2 - 10, cell.profPic.frame.size.height/2 - 10, 20, 20)];
    [av setIndicatorStyle:WDActivityIndicatorStyleGradient];
    [av setNativeIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.hidesWhenStopped = YES;
    [av startAnimating];
    [cell.profPic addSubview:av];
    cell.profPic.image = nil;
    cell.profPic.file = (PFFile*)tempUser[@"profPic"];
    [cell.profPic loadInBackground:^(UIImage *image, NSError *error) {
        [av stopAnimating];
    }];
    
    return cell;
}


@end
