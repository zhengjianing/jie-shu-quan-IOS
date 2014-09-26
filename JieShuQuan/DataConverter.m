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
#import "Friend.h"
#import "Comment.h"

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

// keys in Server API for User
static const NSString *kUserName = @"user_name";
static const NSString *kGroupName = @"group_name";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";
static const NSString *kUserEmail = @"user_email";
static const NSString *kBookCount = @"book_count";
static const NSString *kFriendCount = @"friend_count";
static const NSString *kLocation = @"location";

// keys in Server API for Book
static const NSString *kBookname = @"name";
static const NSString *kBookauthors = @"authors";
static const NSString *kBookimageHref = @"image_href";
static const NSString *kBookdescription = @"description";
static const NSString *kBookauthorInfo = @"author_info";
static const NSString *kBookprice = @"price";
static const NSString *kBookpublisher = @"publisher";
static const NSString *kBookpublishDate = @"publish_date";
static const NSString *kBookId = @"douban_book_id";
static const NSString *kBookAvailable = @"available";

// keys in Server API for Comment
static const NSString *kCommentUserName = @"user_name";
static const NSString *kCommentContent = @"content";
static const NSString *kCommentDate = @"comment_date";

// keys in CoreData for Book
static const NSString *kCDName = @"name";
static const NSString *kCDAuthors = @"authors";
static const NSString *kCDImageHref = @"imageHref";
static const NSString *kCDDescription = @"bookDescription";
static const NSString *kCDAuthorInfo = @"authorInfo";
static const NSString *kCDPrice = @"price";
static const NSString *kCDPublisher = @"publisher";
static const NSString *kCDBookId = @"bookId";
static const NSString *kCDPublishDate = @"publishDate";
static const NSString *kCDAvailability = @"availability";

// keys in CoreData for User
static const NSString *kCDUserId = @"user_id";
static const NSString *kCDUserName = @"user_name";
static const NSString *kCDUserEmail = @"user_email";
static const NSString *kCDAccessToken = @"access_token";
static const NSString *kCDBookCount = @"book_count";
static const NSString *kCDGroupName = @"group_name";
static const NSString *kCDFriendCount = @"friend_count";
static const NSString *kCDLocation = @"location";

// keys in CoreData for Friend
static const NSString *kCDFriendName = @"friend_name";
static const NSString *kCDFriendEmail = @"friend_email";
static const NSString *kCDFriendId = @"friend_id";
static const NSString *kCDFriendBookCount = @"book_count";

// keys in server for Friend
static const NSString *kFriendName = @"friend_name";
static const NSString *kFriendEmail = @"friend_email";
static const NSString *kFriendId = @"friend_id";
static const NSString *kFriendBookCount = @"book_count";


@interface DataConverter ()
+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData;
@end

@implementation DataConverter

#pragma mark - Book

+ (NSMutableArray *)booksArrayFromDoubanSearchResults:(NSData *)searchResults
{
    id object = [NSJSONSerialization JSONObjectWithData:searchResults options:NSJSONReadingAllowFragments error:nil];
    if (!object)
        return nil;
    return [self booksArrayFromUnserializedBooksData:[object valueForKey:@"books"]];
}

+ (Book *)bookFromDoubanBookObject:(id)object
{
    Book *book = [[Book alloc] init];
    book.name = [object valueForKey:(NSString *)kDBTitle];
    book.authors = [[object valueForKey:(NSString *)kDBAuthor] componentsJoinedByString:@","];
    book.imageHref = [object valueForKey:(NSString *)kDBImageHref];
    book.description = [object valueForKey:(NSString *)kDBSummary];
    book.authorInfo = [object valueForKey:(NSString *)kDBAuthorIntro];
    book.price = [object valueForKey:(NSString *)kDBPrice];
    book.publisher = [object valueForKey:(NSString *)kDBPublisher];
    book.publishDate = [object valueForKey:(NSString *)kDBPubdate];
    book.bookId = [object valueForKey:(NSString *)kDBBookId];
    return book;
}

+ (Book *)bookFromServerBookObject:(id)object
{
    Book *book = [[Book alloc] init];
    
    book.name = [object valueForKey:(NSString *)kBookname];
    book.authors = [object valueForKey:(NSString *)kBookauthors];
    book.imageHref = [object valueForKey:(NSString *)kBookimageHref];
    book.description = [object valueForKey:(NSString *)kBookdescription];
    book.authorInfo = [object valueForKey:(NSString *)kBookauthorInfo];
    book.price = [object valueForKey:(NSString *)kBookprice];
    book.publisher = [object valueForKey:(NSString *)kBookpublisher];
    book.publishDate = [object valueForKey:(NSString *)kBookpublishDate];
    book.bookId = [object valueForKey:(NSString *)kBookId];
    book.availability = [[object valueForKey:(NSString *)kBookAvailable] boolValue];
    return book;
}

+ (Book *)bookFromStoreObject:(id)storedBook
{
    Book *book = [[Book alloc] init];
    book.name = [storedBook valueForKey:(NSString *)kCDName];
    book.authors = [storedBook valueForKey:(NSString *)kCDAuthors];
    book.imageHref = [storedBook valueForKey:(NSString *)kCDImageHref];
    book.description = [storedBook valueForKey:(NSString *)kCDDescription];
    book.authorInfo = [storedBook valueForKey:(NSString *)kCDAuthorInfo];
    book.price = [storedBook valueForKey:(NSString *)kCDPrice];
    book.publisher = [storedBook valueForKey:(NSString *)kCDPublisher];
    book.bookId = [storedBook valueForKey:(NSString *)kCDBookId];
    book.publishDate = [storedBook valueForKey:(NSString *)kCDPublishDate];
    book.availability = [[storedBook valueForKey:(NSString *)kCDAvailability] boolValue];
    return book;
}

+ (void)setManagedObject:(id)managedBook forBook:(Book *)book
{
    [managedBook setValue:book.name forKey:(NSString *)kCDName];
    [managedBook setValue:book.authors forKey:(NSString *)kCDAuthors];
    [managedBook setValue:book.imageHref  forKey:(NSString *)kCDImageHref];
    [managedBook setValue:book.description forKey:(NSString *)kCDDescription];
    [managedBook setValue:book.authorInfo forKey:(NSString *)kCDAuthorInfo];
    [managedBook setValue:book.price forKey:(NSString *)kCDPrice];
    [managedBook setValue:book.publisher forKey:(NSString *)kCDPublisher];
    [managedBook setValue:book.bookId forKey:(NSString *)kCDBookId];
    [managedBook setValue:book.publishDate forKey:(NSString *)kCDPublishDate];
    [managedBook setValue:[NSNumber numberWithBool:book.availability] forKey:(NSString *)kCDAvailability];
}

#pragma mark - User

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
    user.location = [object valueForKey:(NSString *)kLocation];
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
    user.location = [storedUser valueForKey:(NSString *)kCDLocation];
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
    [object setValue:user.location forKey:(NSString *)kCDLocation];
}

#pragma mark - Friend

+ (Friend *)friendFromStore:(id)storedFriend
{
    Friend *friend = [[Friend alloc] init];
    friend.friendName = [storedFriend valueForKey:(NSString *)kCDFriendName];
    friend.friendEmail = [storedFriend valueForKey:(NSString *)kCDFriendEmail];
    friend.friendId = [storedFriend valueForKey:(NSString *)kCDFriendId];
    friend.bookCount = [storedFriend valueForKey:(NSString *)kCDFriendBookCount];
    return friend;
}

+ (void)setManagedObject:(id)object forFriend:(Friend *)friend
{
    [object setValue:friend.friendId forKey:(NSString *)kCDFriendId];
    [object setValue:friend.friendName forKey:(NSString *)kCDFriendName];
    [object setValue:friend.friendEmail forKey:(NSString *)kCDFriendEmail];
    [object setValue:friend.bookCount forKey:(NSString *)kCDFriendBookCount];
}

+ (Friend *)friendFromServerFriendObject:(id)object
{
    Friend *friend = [[Friend alloc] init];
    
    friend.friendName = [object valueForKey:(NSString *)kFriendName];
    friend.friendId = [object valueForKey:(NSString *)kFriendId];
    friend.friendEmail = [object valueForKey:(NSString *)kFriendEmail];
    friend.bookCount = [object valueForKey:(NSString *)kFriendBookCount];

    return friend;
}

#pragma mark - Comments

+ (Comment *)commentFromObject:(id)object
{
    Comment *comment = [[Comment alloc] init];
    
    comment.user_name = [object valueForKey:(NSString *)kCommentUserName];
    comment.content = [object valueForKey:(NSString *)kCommentContent];
    comment.comment_date = [object valueForKey:(NSString *)kCommentDate];

    return comment;
}

#pragma mark - private methods

+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData
{
    NSMutableArray *booksArray = [NSMutableArray array];
    
    for (id item in booksData) {
        [booksArray addObject:[self bookFromDoubanBookObject:item]];
    }
    return booksArray;
}

@end
