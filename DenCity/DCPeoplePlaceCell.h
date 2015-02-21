//
//  DCPeoplePlaceCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/7/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kCellHeight = 100;
static const CGFloat kCellWidth = 200;

@class DCPeoplePlaceCell;
@class DCPeopleCell;

@protocol DCPeoplePlaceCellDataSource <NSObject>

- (NSInteger)numberOfCellsInDCPeoplePlaceCell:(DCPeoplePlaceCell*)people;
- (DCPeopleCell*)DCPeoplePlaceCell:(DCPeoplePlaceCell*)people cellForIndex:(NSInteger)index;

@end

@protocol DCPeoplePlaceCellDelegate <NSObject>

- (void)selectedCellAtIndex:(NSInteger)index;

@end

@interface DCPeoplePlaceCell : UIScrollView

@property (nonatomic, weak) id<DCPeoplePlaceCellDataSource> peopleDatasource;
@property (nonatomic, weak) id<DCPeoplePlaceCellDelegate> peopleDelegate;

- (void)reloadData;

@end

@interface DCPeopleCell : UIView{
    DCPeoplePlaceCell *__weak peoplePlaceCell;
    NSInteger index;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *lastNameLabel;
@property (nonatomic, weak, readonly) DCPeoplePlaceCell *peoplePlaceCell;
@property (nonatomic, readonly) NSInteger index;

@end