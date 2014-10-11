//
//  DateHelper.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-10-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString *)currentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

@end
