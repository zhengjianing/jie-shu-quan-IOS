//
//  Book.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "Book.h"

@implementation Book

- (NSString *)authorsString
{
    NSString *authorsString = @"";
    for (NSString *author in _authors) {
        authorsString = [authorsString stringByAppendingString:author];
        if (![author isEqualToString:[_authors lastObject]]) {
            authorsString = [authorsString stringByAppendingString:@", "];
        }
    }
    return authorsString;
}

- (BOOL)isSameBook:(Book *)book
{
    //change book.availability to make sure if searched book alreay exists, then it should have the right availability in the store!
    if ([self.name isEqualToString:book.name] && [self.authors isEqualToArray:book.authors]) {
        book.availability = self.availability;
        return YES;
    } else
        return NO;
}

@end
