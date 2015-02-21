//
//  ParallaxTableViewController.m
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import "JPBParallaxTableViewController.h"

@interface JPBParallaxTableViewController () {
    UIScrollView *_scrollView;
}

@end

@implementation JPBParallaxTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIScrollView *)contentView{
    return [self scrollView];
}

@end
