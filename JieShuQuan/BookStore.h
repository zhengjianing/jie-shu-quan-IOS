//
//  BookStore.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
@class Book;

@interface BookStore : Store

+ (BookStore *)sharedStore;

- (NSArray *)storedBooks;
- (void)refreshStoredBooks;
- (void)addBookToStore:(Book *)book;
- (BOOL)storeHasBook:(Book *)book;
- (void)changeStoredBookStatusWithBook:(Book *)book;
- (void)emptyBookStoreForCurrentUser;

@end
