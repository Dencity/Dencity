//
//  DCUberView.h
//  DenCity
//
//  Created by Dylan Humphrey on 2/24/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UberKit.h>
#import <MapKit/MapKit.h>

@interface DCUberView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    @private
    CLLocation *startLocation;
    CLLocation *endLocation;
    
    NSMutableArray *products;
    NSMutableArray *prices;
    NSMutableArray *times;
    
    NSString *serverToken;
}

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame
                  serverToken:(NSString*)token
                startLocation:(CLLocation*)location
                  endLocation:(CLLocation*)eLocation;

+ (NSString*)serverToken;

@end

@interface DCUberViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@interface UIColor (DCUberColors)

+ (UIColor*)uberBlue;
+ (UIColor*)uberLightGray;

@end