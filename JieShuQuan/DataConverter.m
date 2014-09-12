//
//  DataConverter.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "DataConverter.h"
#import "Book.h"
#import "User.h"

// keys in Douban API
static const NSString *kDBTitle = @"title";
static const NSString *kDBAuthor = @"author";
static const NSString *kDBImageHref = @"image";
static const NSString *kDBSummary = @"summary";
static const NSString *kDBAuthorIntro = @"author_intro";
static const NSString *kDBPrice = @"price";
static const NSString *kDBPublisher = @"publisher";
static const NSString *kDBPubdate = @"pubdate";
static const NSString *kDBBookId = @"id";

// keys in Server API
static const NSString *kUserName = @"user_name";
static const NSString *kGroupName = @"group_name";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";
static const NSString *kUserEmail = @"user_email";
static const NSString *kBookCount = @"book_count";
static const NSString *kFriendCount = @"friend_count";

// keys in CoreData
static const NSString *kDBUserId = @"user_id";
static const NSString *kDBUserName = @"user_name";
static const NSString *kDBUserEmail = @"user_email";
static const NSString *kDBAccessToken = @"access_token";
static const NSString *kDBBookCount = @"book_count";
static const NSString *kDBGroupName = @"group_name";
static const NSString *kDBFriendCount = @"friend_count";

@interface DataConverter ()
+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData;
@end

@implementation DataConverter

#pragma mark -- Book

+ (NSMutableArray *)booksArrayFromJsonData:(NSData *)jsonData
{
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (!object) {
        return nil;
    }

    return [self booksArrayFromUnserializedBooksData:[object valueForKey:@"books"]];
}

+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData
{
    NSMutableArray *booksArray = [NSMutableArray array];
    
    for (id item in booksData) {
        Book *book = [[Book alloc] init];
        book.name = [item valueForKey:(NSString *)kDBTitle];
        book.authors = [item valueForKey:(NSString *)kDBAuthor];
        book.imageHref = [item valueForKey:(NSString *)kDBImageHref];
        book.description = [item valueForKey:(NSString *)kDBSummary];
        book.authorInfo = [item valueForKey:(NSString *)kDBAuthorIntro];
        book.price = [item valueForKey:(NSString *)kDBPrice];
        book.publisher = [item valueForKey:(NSString *)kDBPublisher];
        book.publishDate = [item valueForKey:(NSString *)kDBPubdate];
        book.bookId = [item valueForKey:(NSString *)kDBBookId];
        
        [booksArray addObject:book];
    }
    return booksArray;
}

#pragma mark -- User

+ (User *)userFromHTTPResponse:(id)object
{
    User *user = [[User alloc] init];
    user.userName = [object valueForKey:(NSString *)kUserName];
    user.groupName = [object valueForKey:(NSString *)kGroupName];
    user.accessToken = [object valueForKey:(NSString *)kAccessToken];
    user.userId = [object valueForKey:(NSString *)kUserId];
    user.userEmail = [object valueForKey:(NSString *)kUserEmail];
    user.bookCount = [object valueForKey:(NSString *)kBookCount];
    user.friendCount = [object valueForKey:(NSString *)kFriendCount];
    return user;
}

+ (User *)userFromManagedObject:(id)storedUser
{
    User *user = [[User alloc] init];
    user.userId = [storedUser valueForKey:(NSString *)kDBUserId];
    user.userName = [storedUser valueForKey:(NSString *)kDBUserName];
    user.groupName = [storedUser valueForKey:(NSString *)kDBGroupName];
    user.bookCount = [storedUser valueForKey:(NSString *)kDBBookCount];
    user.userEmail = [storedUser valueForKey:(NSString *)kDBUserEmail];
    user.accessToken = [storedUser valueForKey:(NSString *)kDBAccessToken];
    user.friendCount = [storedUser valueForKey:(NSString *)kDBFriendCount];
    return user;
}

+ (void)setManagedObject:(id)object forUser:(User *)user
{
    [object setValue:user.userId forKey:(NSString *)kDBUserId];
    [object setValue:user.userName forKey:(NSString *)kDBUserName];
    [object setValue:user.groupName forKey:(NSString *)kDBGroupName];
    [object setValue:user.userEmail forKey:(NSString *)kDBUserEmail];
    [object setValue:user.bookCount forKey:(NSString *)kDBBookCount];
    [object setValue:user.accessToken forKey:(NSString *)kDBAccessToken];
    [object setValue:user.friendCount forKey:(NSString *)kDBFriendCount];
}

@end
