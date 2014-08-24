//
//  Book.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) NSString *imageHref;
@property (strong, nonatomic) NSString *discription;
@property (strong, nonatomic) NSString *authorInfo;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *publishDate;

- (id)initWithName:(NSString *)name authors:(NSArray *)authors imageHref:(NSString *)imageHref discription:(NSString *)discription authorInfo:(NSString *)authorInfo price:(NSString *)price publisher:(NSString *)publisher publishDate:(NSString *)publishDate;

- (NSString *)authorsString;

@end
