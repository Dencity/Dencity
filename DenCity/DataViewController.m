//
//  DataViewController.m
//  DenCity
//
//  Created by Dylan Humphrey on 10/4/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import "DataViewController.h"
#import "DataGatherer.h"


@interface DataViewController (){
    DataGatherer *dataGatherer;
}

@end

@implementation DataViewController

- (id)init{
    self = [super init];
    if (self) {
        dataGatherer = [[DataGatherer alloc]init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor = [UIColor redColor];
    [self.view addSubview:statusBarView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self performSelector:@selector(startRunning) withObject:nil afterDelay:3.0];
}

- (void)startRunning{
    [dataGatherer places];
}

@end
