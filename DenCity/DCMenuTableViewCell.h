//
//  DCMenuTableViewCell.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/6/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCMenuTableViewCell : UITableViewCell{
    UIImageView *menuImageView;
    CGRect originalImageFrame;
    CGRect toImageFrame;
}

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@end
