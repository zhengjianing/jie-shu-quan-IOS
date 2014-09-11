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

// keys in Server API
static const NSString *kUserName = @"user_name";
static const NSString *kGroupName = @"group_name";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";
static const NSString *kUserEmail = @"user_email";

// keys in CoreData
static const NSString *kDBUserId = @"user_id";
static const NSString *kDBUserName = @"user_name";
static const NSString *kDBUserEmail = @"user_email";
static const NSString *kDBAccessToken = @"access_token";
static const NSString *kDBBookCount = @"book_count";
static const NSString *kDBGroupName = @"group_name";


@interface DataConverter ()
+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData;
@end

@implementation DataConverter

+ (NSMutableArray *)booksArrayFromJsonData:(NSData *)jsonData
{
    id object;
    if (jsonData) {
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (!object) {
            NSLog(@"Convertion From JsonData To FoundationObject Failed: %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else {
        NSLog(@"Invalid Data...");
        abort();
    }
    return [self booksArrayFromUnserializedBooksData:[object valueForKey:@"books"]];
}

+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData
{
    NSMutableArray *booksArray = [NSMutableArray array];
    
    for (id item in booksData) {
        Book *book = [[Book alloc] init];
        book.name = [item valueForKey:@"title"];
        book.authors = [item valueForKey:@"author"];
        book.imageHref = [item valueForKey:@"image"];
        book.description = [item valueForKey:@"summary"];
        book.authorInfo = [item valueForKey:@"author_intro"];
        book.price = [item valueForKey:@"price"];
        book.publisher = [item valueForKey:@"publisher"];
        book.publishDate = [item valueForKey:@"pubdate"];
        book.bookId = [item valueForKey:@"id"];
        
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
}

@end
