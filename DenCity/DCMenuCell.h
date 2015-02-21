//
//  DCMenuCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/4/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCMenuCell;

@protocol DCMenuCellDelegate <NSObject>

- (void)selectedDCMenuCell:(DCMenuCell*)cell;

@end

@interface DCMenuCell : UIView{
}

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *centerLabel;
@property BOOL selected;
@property (nonatomic, weak) id<DCMenuCellDelegate> delegate;

- (void)toggleSelection;

@end
