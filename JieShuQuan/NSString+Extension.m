//
//  NSString+Extension.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 11/14/15.
//  Copyright (c) 2015 JNXZ. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isEmptyOrNilString:(NSString *)string {
    return !string || [string isEqualToString:@""];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter dateFromString:[dateString componentsSeparatedByString:@"T"][0]];
    }
    return nil;
}

@end

