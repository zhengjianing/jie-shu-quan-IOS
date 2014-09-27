//
//  CustomActivityIndicator.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomActivityIndicator.h"

@interface CustomActivityIndicator ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation CustomActivityIndicator

- (id)init
{
    self = [super init];
    if (self) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _activityIndicator.hidesWhenStopped = YES;
        
        [self setFrame:CGRectMake(135, 170, 50, 50)];
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.cornerRadius = 5.0;
        [self addSubview:_activityIndicator];
        
        self.hidden = YES;
    }
    return self;
}

- (void)startAnimating
{
    [self setHidden:NO];
    [_activityIndicator startAnimating];
}

- (void)stopAnimating
{
    [_activityIndicator stopAnimating];
    [self setHidden:YES];
}

@end
