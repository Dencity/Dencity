//
//  JPBFloatingTextViewController.h
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import "JPBParallaxTableViewController.h"

@interface JPBFloatingTextViewController : JPBParallaxTableViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

- (void)setTitleText:(NSString*)text;
- (void)setSubtitleText:(NSString*)text;
- (void)selLabelBackground:(UIColor*)color;
- (void)setLabelBackgroundGradientColor:(UIColor*)bottomColor;
- (CGFloat)horizontalOffset;

@end
