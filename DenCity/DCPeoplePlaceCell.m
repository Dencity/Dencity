//
//  DCPeoplePlaceCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/7/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPeoplePlaceCell.h"

@implementation DCPeoplePlaceCell

@synthesize peopleDelegate, peopleDatasource;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self loadCellData];
}

- (void)loadCellData{
    NSLog(@"%li", (long)[self.peopleDatasource numberOfCellsInDCPeoplePlaceCell:self]);
    self.contentSize = CGSizeMake(kCellWidth*[self.peopleDatasource numberOfCellsInDCPeoplePlaceCell:self], kCellHeight);
    for (NSInteger i = 0; i < [self.peopleDatasource numberOfCellsInDCPeoplePlaceCell:self]; i++) {
        DCPeopleCell *cell = [self.peopleDatasource DCPeoplePlaceCell:self cellForIndex:i];
        [cell performSelector:@selector(setIndex:) withObject:[NSNumber numberWithInteger:i]];
        [cell performSelector:@selector(setPeoplePlaceCell:) withObject:self];
        cell.frame = CGRectMake(i*kCellWidth, 0, kCellWidth, kCellHeight);
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = .25f;
        [self addSubview:cell];
    }
}


- (void)reloadData{
    [self setNeedsDisplay];
}

- (void)cellWasSelected:(DCPeopleCell*)cell{
    [self.peopleDelegate selectedCellAtIndex:cell.index];
}

@end

@interface DCPeopleCell ()

@property (nonatomic, assign) DCPeoplePlaceCell *peoplePlaceCell;

@end

@implementation DCPeopleCell

@synthesize imageView, firstNameLabel, lastNameLabel, peoplePlaceCell, index;

- (void)layoutSubviews{
    [self setUpViews];
}

- (void)setIndex:(NSNumber*)theIndex{
    index = [theIndex intValue];
}

- (void)setUpViews{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.center = CGPointMake(self.center.x, self.center.y - 15);
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.borderWidth = .5f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:imageView];
    
    firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, self.frame.size.width, 30)];
    firstNameLabel.textAlignment = NSTextAlignmentCenter;
    firstNameLabel.font = [UIFont systemFontOfSize:16];
    firstNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:firstNameLabel];
    
    lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, firstNameLabel.frame.origin.y + firstNameLabel.frame.size.height + 5, self.frame.size.width, 30)];
    lastNameLabel.textAlignment = NSTextAlignmentCenter;
    lastNameLabel.font = [UIFont systemFontOfSize:16];
    lastNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:lastNameLabel];
}

#pragma mark - Touch Even Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (peoplePlaceCell) {
        [peoplePlaceCell performSelector:@selector(cellWasSelected:) withObject:self afterDelay:.3];
    }
}

@end

