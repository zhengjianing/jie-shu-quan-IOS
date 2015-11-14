//
//  NSString+Extension.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 11/14/15.
//  Copyright (c) 2015 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (BOOL)isEmptyOrNilString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string;

@end
