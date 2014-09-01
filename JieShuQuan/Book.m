//
//  Book.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id)initWithName:(NSString *)name authors:(NSArray *)authors imageHref:(NSString *)imageHref discription:(NSString *)discription authorInfo:(NSString *)authorInfo price:(NSString *)price publisher:(NSString *)publisher publishDate:(NSString *)publishDate bookId:(NSString *)bookId
{
    self = [super init];
    if (self) {
        self.name = name;
        self.authors = authors;
        self.imageHref = imageHref;
        self.discription = discription;
        self.authorInfo = authorInfo;
        self.price = price;
        self.publisher = publisher;
        self.publishDate = publishDate;
        self.bookId = bookId;
    }
    return self;
}

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

@end
