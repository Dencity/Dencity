//
//  MainViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 8/13/14.
//  Copyright (c) 2014 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ScrollDirection){
    ScrollDirectionNone = 0,
    ScrollDirectionRight = 1 << 1,
    ScrollDirectionleft = 1 << 2,
    ScrollDirectionUp = 1 << 3,
    ScrollDirectionDown = 1 << 4,
    ScrollDirectionCrazy = 1 << 5,
};

typedef NS_OPTIONS(NSInteger, Type){
    TypeBoth = 0,
    TypeBar = 1 << 1,
    TypeNight = 1 << 2,
};

typedef NS_OPTIONS(NSInteger, Filter){
    FilterNone = 0,
    FilterPopulation = 1 << 1,
    FilterLocation = 1 << 2,
};

@interface MainViewController : UITableViewController

@property (nonatomic, assign) ScrollDirection scrollDirection;

@property (nonatomic, assign) Type type;

@property (nonatomic, assign) Filter filter;

@end
