//
//  DCPlaceCollectionView.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/28/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPlaceCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *placeImages;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout data:(NSArray*)data;

- (void)reloadImageData:(NSArray*)objects;

@end
