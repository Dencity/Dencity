//
//  DCPopulationPlaceCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/5/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCPopulationPlaceCell;

@protocol DCPopulationPlaceCellDelegate <NSObject>

- (void)buttonWasPressed:(BOOL)selected;

@end

@interface DCPopulationPlaceCell : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *popLabel;
@property (nonatomic, strong) UILabel *oldPopLabel;
@property (nonatomic, weak) id<DCPopulationPlaceCellDelegate> delegate;

@end
