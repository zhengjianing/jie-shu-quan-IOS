//
//  CustomActivityIndicator.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomActivityIndicator.h"

#define SPINRECT CGRectMake(135, 290, 50, 50)

#define SCREENRECT [[UIScreen mainScreen] bounds]


@interface CustomActivityIndicator ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *freezeLayer;

@end

@implementation CustomActivityIndicator

+ (CustomActivityIndicator *)sharedActivityIndicator
{
    static CustomActivityIndicator *sharedActivityIndicator;
    if (!sharedActivityIndicator) {
        sharedActivityIndicator = [[super allocWithZone:nil] init];
    }
    return sharedActivityIndicator;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedActivityIndicator];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        
        [self addSubview:self.freezeLayer];
        [self addSubview:self.activityIndicator];
        self.hidden = YES;
    }
    return self;
}


#pragma mark - setters

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_activityIndicator setFrame:SPINRECT];

    _activityIndicator.hidesWhenStopped = YES;
    return _activityIndicator;
}

- (UIView *)freezeLayer
{
    if (_freezeLayer != nil) {
        return _freezeLayer;
    }
    
    _freezeLayer = [[UIView alloc] initWithFrame:SCREENRECT];
    _freezeLayer.backgroundColor = [UIColor blackColor];
    _freezeLayer.alpha = 0.3;
    return _freezeLayer;
}

#pragma mark - Asynchronous -- without gray mask
- (void)startAsynchAnimating
{
    [_freezeLayer setFrame:SPINRECT];
    _freezeLayer.layer.cornerRadius = 5.0;
    _freezeLayer.alpha = 0.8;
    
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopAsynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
    
    [_freezeLayer setFrame:SCREENRECT];
    _freezeLayer.layer.cornerRadius = 0;
    _freezeLayer.alpha = 0.3;

}

#pragma mark - Synchronous -- with gray mask

- (void)startSynchAnimating
{
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopSynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
}


@end
