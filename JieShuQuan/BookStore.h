//
//  BookStore.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@class Book;

@interface BookStore : NSObject

+ (BookStore *)sharedStore;
- (NSArray *)storedBooks;
- (void)refreshStore;
- (void)addBookToStore:(Book *)book;
- (BOOL)storeHasBook:(Book *)book;

@end
