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
@class Friend;

@interface DataConverter : NSObject

// users
+ (User *)userFromHTTPResponse:(id)object;
+ (User *)userFromManagedObject:(id)storedUser;
+ (void)setManagedObject:(id)object forUser:(User *)user;

// books
+ (NSMutableArray *)booksArrayFromDoubanSearchResults:(NSData *)searchResults;
+ (Book *)bookFromServerBookObject:(id)object;
+ (Book *)bookFromStoreObject:(id)storedBook;
+ (void)setManagedObject:(id)object forBook:(Book *)book;

// friends
+ (Friend *)friendFromStore:(id)object;
+ (void)setManagedObject:(id)object forFriend:(Friend *)friend;
+ (Friend *)friendFromServerFriendObject:(id)object;

@end
