//
//  ParallaxTableViewController.h
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import "JPBParallaxBlurViewController.h"

@interface JPBParallaxTableViewController : JPBParallaxBlurViewController <UIScrollViewDelegate>

@property (readonly) UIScrollView *scrollView;

- (UIScrollView*)contentView;

@end
