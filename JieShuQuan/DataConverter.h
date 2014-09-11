//
//  DataConverter.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Book;
@class User;

@interface DataConverter : NSObject

+ (NSMutableArray *)booksArrayFromJsonData:(NSData *)jsonData;
+ (User *)userFromObject:(id)object;

@end
