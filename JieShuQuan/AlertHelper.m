//
//  AlertHelper.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

+ (void)showAlertWithMessage:(NSString *)message target:(id)target
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:target cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:2.0];
    [alertView show];
}

+ (void)dismissAlert:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}


@end