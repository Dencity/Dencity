//
//  DCPlaceViewController.h
//  DenCity
//
//  Created by Dylan Humphrey on 1/19/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import <Parse/Parse.h>
#import "DCPlace.h"
#import "MarqueeLabel.h"

@interface DCPlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    MarqueeLabel *placeNameLabel;
    UILabel *placeAddressLabel;
    
    UIButton *backButton;
    
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *nonBlurBackgroundImageView;
@property (nonatomic, strong) DCPlace *place;

- (id)initWithPlace:(NSString*)place;

@end
