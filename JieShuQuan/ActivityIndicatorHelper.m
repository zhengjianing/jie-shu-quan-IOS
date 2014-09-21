//
//  ActivityIndicatorHelper.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ActivityIndicatorHelper.h"

@implementation ActivityIndicatorHelper

+ (UIActivityIndicatorView *)activityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.hidesWhenStopped = YES;
    return activityIndicator;
}

@end
