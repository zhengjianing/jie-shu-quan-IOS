//
//  Book.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "Book.h"

@implementation Book

- (BOOL)isSameBook:(Book *)book
{
    //change book.availability to make sure if searched book alreay exists, then it should have the right availability in the store!
    if ([self.name isEqualToString:book.name] && [self.authors isEqualToString:book.authors]) {
        book.availability = self.availability;
        return YES;
    } else
        return NO;
}

@end
