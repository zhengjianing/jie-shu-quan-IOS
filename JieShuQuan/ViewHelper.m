//
//  ViewHelper.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/19/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (void)showMessage:(NSString *)message onView:(UIView *)view
{
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 200.0)];
    messageLabel.text = message;
    messageLabel.textAlignment = UITextAlignmentCenter;
    [view addSubview:messageLabel];
}

@end
