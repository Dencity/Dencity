//
//  DCPopulationPlaceCell.m
//  DenCity
//
//  Created by Dylan Humphrey on 2/5/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "DCPopulationPlaceCell.h"

@interface DCPopulationPlaceCell (){
    UIView *populationView;
    UIView *oldPopulationView;
    
    UIImageView *populationImageView;
    UIImageView *oldPopulationImageView;
    
    UIButton *populationButton;
    UIButton *oldPopulationButton;
    
    BOOL selected;
}

@end

@implementation DCPopulationPlaceCell

@synthesize oldPopLabel, popLabel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self normalSetup];
    }
    return self;
}

- (void)normalSetup{
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
    self.clipsToBounds = YES;
    
    //setting up the population view
    populationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    populationView.backgroundColor = [UIColor clearColor];
    populationView.layer.borderColor = [UIColor whiteColor].CGColor;
    populationView.layer.borderWidth = .5;
    
    populationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    populationImageView.image = [UIImage imageNamed:@"place_PopulationView"];
    [populationView addSubview:populationImageView];
    
    CGFloat inset = populationImageView.frame.origin.x + populationImageView.frame.size.width + 5;
    popLabel = [[UILabel alloc]initWithFrame:CGRectMake(inset, 0, self.frame.size.width-inset, 50)];
    popLabel.textColor = [UIColor whiteColor];
    popLabel.font = [UIFont systemFontOfSize:16];
    [populationView addSubview:popLabel];
    
    populationButton = [[UIButton alloc]initWithFrame:CGRectMake(populationView.frame.size.width - 110, 12.5, 100, 25)];
    populationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    populationButton.layer.borderWidth = 1.0f;
    populationButton.layer.cornerRadius = 10.0f;
    populationButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [populationButton setBackgroundColor:[UIColor clearColor]];
    [populationButton setTitle:@"Show Trends" forState:UIControlStateNormal];
    [populationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [populationButton addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [populationView addSubview:populationButton];
    
    [self addSubview:populationView];
    
    //setting up the old population view
    oldPopulationView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, 50)];
    oldPopulationView.backgroundColor = [UIColor clearColor];
    oldPopulationView.layer.borderColor = [UIColor whiteColor].CGColor;
    oldPopulationView.layer.borderWidth = .5;
    
    oldPopLabel = [[UILabel alloc]initWithFrame:CGRectMake(inset, 0, self.frame.size.width-inset, 50)];
    oldPopLabel.textColor = [UIColor whiteColor];
    oldPopLabel.font = [UIFont systemFontOfSize:16];
    [oldPopulationView addSubview:oldPopLabel];
    
    oldPopulationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    oldPopulationImageView.image = [UIImage imageNamed:@"place_PopulationView"];
    [oldPopulationView addSubview:oldPopulationImageView];
    
    oldPopulationButton = [[UIButton alloc]initWithFrame:CGRectMake(populationView.frame.size.width - 110, 12.5, 100, 25)];
    oldPopulationButton.titleLabel.font = [UIFont systemFontOfSize:13];
    oldPopulationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    oldPopulationButton.layer.borderWidth = 1.0f;
    oldPopulationButton.layer.cornerRadius = 10.0f;
    [oldPopulationButton setBackgroundColor:[UIColor clearColor]];
    [oldPopulationButton setTitle:@"Show Trends" forState:UIControlStateNormal];
    [oldPopulationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oldPopulationButton addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [oldPopulationView addSubview:oldPopulationButton];
    
    [self addSubview:oldPopulationView];
}

- (void)handleButtonPress:(id)sender{
    if (selected) {
        selected = NO;
        [populationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [populationButton setBackgroundColor:[UIColor clearColor]];
        [oldPopulationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [oldPopulationButton setBackgroundColor:[UIColor clearColor]];
        [self.delegate buttonWasPressed:selected];
    }
    else{
        selected = YES;
        [populationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [populationButton setBackgroundColor:[UIColor whiteColor]];
        [oldPopulationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [oldPopulationButton setBackgroundColor:[UIColor whiteColor]];
        [self.delegate buttonWasPressed:selected];
    }
}

@end
