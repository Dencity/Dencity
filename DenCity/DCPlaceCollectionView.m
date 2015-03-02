//
//  DCPlaceCollectionView.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/28/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPlaceCollectionView.h"
#import <Parse/Parse.h>
#import "DCPlaceImage.h"
#import "WDActivityIndicator.h"
#import "DCPlaceCollectionViewCell.h"
#import <UIImageView+RJLoader.h>

@implementation DCPlaceCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout data:(NSArray*)data{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerClass:[DCPlaceCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self loadImageData:data];
        self.scrollEnabled = YES;
    }
    return self;
}


- (void)loadImageData:(NSArray*)objects{
    WDActivityIndicator *ind = [[WDActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    ind.center = self.center;
    ind.indicatorStyle = WDActivityIndicatorStyleGradient;
    ind.hidesWhenStopped = YES;
    [self addSubview:ind];
    [ind startAnimating];
    
    PFQuery *query = [DCPlaceImage query];
    [query whereKey:@"objectId" containedIn:objects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ind stopAnimating];
            _placeImages = [NSMutableArray arrayWithArray:objects];
            [self reloadData];
        }
    }];
}

- (void)reloadImageData:(NSArray*)objects{
    [self loadImageData:objects];
}

#pragma mark - Collection View Protocols

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _placeImages.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DCPlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    DCPlaceImage *image = _placeImages[indexPath.row];
    PFFile *file = image.imageFile;
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }];
    
    return cell;
}

@end
