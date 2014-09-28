//
//  CustomActivityIndicator.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomActivityIndicator.h"

#define SPINRECT CGRectMake(150, 230, 20, 20)
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
        [self setFrame:SCREENRECT];
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
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:SPINRECT];

    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    return _activityIndicator;
}

- (UIView *)freezeLayer
{
    if (_freezeLayer != nil) {
        return _freezeLayer;
    }
    
    _freezeLayer = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.x, self.frame.size.width, self.frame.size.height)];
    _freezeLayer.backgroundColor = [UIColor blackColor];
    _freezeLayer.alpha = 0.3;
    return _freezeLayer;
}

#pragma mark - Asynchronous -- without gray mask
- (void)startAsynchAnimating
{
    [self setFrame:CGRectMake(150, 230, 20, 20)];
    [_activityIndicator setFrame:self.window.frame];
    _freezeLayer.hidden = YES;
    
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopAsynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
    _freezeLayer.hidden = NO;
    
    [self setFrame:SCREENRECT];
    [_activityIndicator setFrame:SPINRECT];
}

#pragma mark - Synchronous -- with gray mask

- (void)startSynchAnimating
{
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopSynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
    
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}


@end
