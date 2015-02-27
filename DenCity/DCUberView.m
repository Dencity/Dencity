//
//  DCUberView.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/24/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCUberView.h"
#import <UberKit/UberKit.h>

@class DCUberViewCell;

@implementation DCUberView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
                  serverToken:(NSString *)token
                startLocation:(CLLocation *)location
                  endLocation:(CLLocation *)eLocation
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor cyanColor];
        serverToken = token;
        startLocation = location;
        endLocation = eLocation;
        
        [self loadUberData];
    }
    return self;
}

- (void)layoutSubviews{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];}

+ (NSString*)serverToken{
    return @"b1_jiiC0ylWvGaYmWk3xCDPIJilm7YvffXyuLlOk";
}

#pragma mark - Class Methods

- (void)loadUberData{
    [[UberKit sharedInstance] setServerToken:[DCUberView serverToken]];
    [[UberKit sharedInstance] getProductsForLocation:startLocation withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
        if (!error) {
            products = [NSMutableArray arrayWithArray:resultsArray];
            [self tableViewShouldReload];
        }
        else{
            
        }
    }];
    [[UberKit sharedInstance] getTimeForProductArrivalWithLocation:startLocation withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
        if (!error) {
            times = [NSMutableArray arrayWithArray:resultsArray];
            [self tableViewShouldReload];
        }
        else{
            
        }
    }];
}

- (void)tableViewShouldReload{
    if (!products || !times) {
        return;
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewCellDelegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return products.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"cell";
    
    DCUberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[DCUberViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UberProduct *product = products[indexPath.row];
    UberTime *time;
    UberPrice *price;
    if (times.count < indexPath.row){
       time = times[indexPath.row];
    }
    if (prices.count < indexPath.row){
        price = prices[indexPath.row];
    }
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:product.image]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@:%f", product.display_name, price.estimate, time.estimate];
    
    return cell;
}

@end

@implementation DCUberViewCell


@end

@implementation UIColor (DCUberColors)

+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:(UInt32)x];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UIColor*)uberBlue{
    return [self colorWithHexString:@"#1fbad6"];

}

+ (UIColor *)uberLightGray {
    return [self colorWithHexString:@"#f2f2f4"];
}

@end