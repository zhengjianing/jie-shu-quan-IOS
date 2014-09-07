//
//  Book.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *authors;
@property (copy, nonatomic) NSString *imageHref;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *authorInfo;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *publisher;
@property (copy, nonatomic) NSString *publishDate;
@property (copy ,nonatomic) NSString *bookId;

- (NSString *)authorsString;

@end
