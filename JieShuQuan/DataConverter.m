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
static const NSString *kCDUserId = @"user_id";
static const NSString *kCDUserName = @"user_name";
static const NSString *kCDUserEmail = @"user_email";
static const NSString *kCDAccessToken = @"access_token";
static const NSString *kCDBookCount = @"book_count";
static const NSString *kCDGroupName = @"group_name";
static const NSString *kCDFriendCount = @"friend_count";
static const NSString *kCDAvailability = @"availability";

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
        
        //豆瓣搜索出来的结果，没有available这个属性
//        book.availability = [[item valueForKey:(NSString *)kCDAvailability] boolValue];
        
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
    user.userId = [storedUser valueForKey:(NSString *)kCDUserId];
    user.userName = [storedUser valueForKey:(NSString *)kCDUserName];
    user.groupName = [storedUser valueForKey:(NSString *)kCDGroupName];
    user.bookCount = [storedUser valueForKey:(NSString *)kCDBookCount];
    user.userEmail = [storedUser valueForKey:(NSString *)kCDUserEmail];
    user.accessToken = [storedUser valueForKey:(NSString *)kCDAccessToken];
    user.friendCount = [storedUser valueForKey:(NSString *)kCDFriendCount];
    return user;
}

+ (void)setManagedObject:(id)object forUser:(User *)user
{
    [object setValue:user.userId forKey:(NSString *)kCDUserId];
    [object setValue:user.userName forKey:(NSString *)kCDUserName];
    [object setValue:user.groupName forKey:(NSString *)kCDGroupName];
    [object setValue:user.userEmail forKey:(NSString *)kCDUserEmail];
    [object setValue:user.bookCount forKey:(NSString *)kCDBookCount];
    [object setValue:user.accessToken forKey:(NSString *)kCDAccessToken];
    [object setValue:user.friendCount forKey:(NSString *)kCDFriendCount];
}

@end
