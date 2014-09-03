//
//  NSArrayTransformer.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-1.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "NSArrayTransformer.h"

@implementation NSArrayTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    NSArray *array = (NSArray *)value;
    NSString *tranString = [array componentsJoinedByString:@", "];
    NSData *data = [tranString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (id)reverseTransformedValue:(id)value
{
    NSString *tranString = [[NSString alloc] initWithData:(NSData *)value encoding:NSUTF8StringEncoding];
    NSArray *array = [tranString componentsSeparatedByString:@", "];
    return array;
}

@end
