//
//  CustomAlert.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(80, 400, 160, 30)];
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.hidden = YES;
    }
    return self;
}

- (void)showAlertWithMessage:(NSString *)message
{
    self.text = message;
    self.hidden = NO;
    if (YES) {
        [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2.0];
    }
}

- (void)dismissAlert
{
    self.hidden = YES;
}

@end
