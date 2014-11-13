//
//  RequestBuilder.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "RequestBuilder.h"
#import "NSString+AES256.h"
#import "ServerHeaders.h"
#import "Book.h"

@implementation RequestBuilder

static const NSString *kPasswordKey = @"passwordKey";

static const NSString *kUserId = @"user_id";
static const NSString *kAccessToken = @"access_token";
static const NSString *kAvatarData = @"avatar";

// keys in Server
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
static const NSString *kCommentContent = @"content";
static const NSString *kUserName = @"user_name";
static const NSString *kBorrowerId = @"borrower_id";
static const NSString *kLenderId = @"lender_id";

static const NSString *kDefaultName = @"匿名用户";

#pragma mark - User

+ (NSMutableURLRequest *)buildRegisterRequestWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *registerBody = @{@"email": email, @"password": [self encrypePassword:password]};
    
    return [self buildRequestWithURLString:kRegisterURL bodyDict:registerBody];
}

+ (NSMutableURLRequest *)buildLoginRequestWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *loginBody = @{@"email": email, @"password": [self encrypePassword:password]};
    
    return [self buildRequestWithURLString:kLoginURL bodyDict:loginBody];
}

+ (NSMutableURLRequest *)buildChangeUserNameRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken UserName:(NSString *)newName
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"user_id", accessToken, @"access_token", newName, @"user_name", nil];
    
    return [self buildRequestWithURLString:kChangeUserNameURL bodyDict:bodyDict];
}

+ (NSMutableURLRequest *)buildChangeUserPhoneNumberRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken UserPhoneNumber:(NSString *)newNumber
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"user_id", accessToken, @"access_token", newNumber, @"phone_number", nil];
    
    return [self buildRequestWithURLString:kChangeUserPhoneNumberURL bodyDict:bodyDict];
}

+ (NSMutableURLRequest *)buildChangeUserLocationRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken location:(NSString *)location
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"user_id", accessToken, @"access_token", location, @"location", nil];
    
    return [self buildRequestWithURLString:kChangeUserLocationURL bodyDict:bodyDict];
}

#pragma mark - Books

+ (NSMutableURLRequest *)buildAddBookRequestWithBook:(Book *)book available:(BOOL)availability userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              book.name, kBookname,
                              book.authors, kBookauthors,
                              book.imageHref, kBookimageHref,
                              book.bookDescription, kBookdescription,
                              book.authorInfo, kBookauthorInfo,
                              book.price, kBookprice,
                              book.publisher, kBookpublisher,
                              book.publishDate, kBookpublishDate,
                              book.bookId, kBookId,
                              [NSNumber numberWithInteger:availability], kBookAvailable,
                              userId, kUserId,
                              accessToken, kAccessToken, nil];
    return [self buildRequestWithURLString:kAddBookURL bodyDictionary:bodyDict HTTPMethod:@"POST"];
}

+ (NSMutableURLRequest *)buildDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    return [self buildRequestWithURLString:kDeleteBookURL bodyDictionary:bodyDict HTTPMethod:@"PUT"];
}

+ (NSMutableURLRequest *)buildChangeBookAvailabilityRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kBookAvailable,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    return [self buildRequestWithURLString:kChangeBookStatusURL bodyDictionary:bodyDict HTTPMethod:@"PUT"];
}

+ (NSMutableURLRequest *)buildFetchBooksRequestForUserId:(NSString *)userId
{
    NSString *urlString = [kMyBooksURL stringByAppendingString:userId];
    return [self buildGetRequestWithRULString:urlString];
}

#pragma mark - Comments

+ (NSMutableURLRequest *)buildGetBookCommentsRequestWithBookId:(NSString *)bookId
{
    NSString *urlString = [kGetBookCommentsURL stringByAppendingString:bookId];
    return [self buildGetRequestWithRULString:urlString];
}

+ (NSMutableURLRequest *)buildPostBookCommentRequestWithBookId:(NSString *)bookId userName:(NSString *)userName content:(NSString *)content
{
    // handles [[UserManager currentUser] userName] == @""(即user didn't set a userName) situation
    userName = ([userName isEqualToString:@""]) ? (NSString *)kDefaultName : userName;
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              userName, kUserName,
                              content, kCommentContent,nil];
    return [self buildRequestWithURLString:kPostBookCommentURL bodyDict:bodyDict];
}

#pragma mark - collect book borrowing info request

+ (NSMutableURLRequest *)buildPostCollectBookBorrowingInfoRequestWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              borrowerId, kBorrowerId,
                              lenderId, kLenderId, nil];
    return [self buildRequestWithURLString:kCollectBorrowingInfoURL bodyDict:bodyDict];
}

#pragma mark - Friends

+ (NSMutableURLRequest *)buildFetchFriendsRequestForUserId:(NSString *)userId
{
    NSString *urlString = [kMyFriendsURL stringByAppendingString:userId];
    return [self buildGetRequestWithRULString:urlString];
}

+ (NSMutableURLRequest *)buildFetchFriendsRequestForUserId:(NSString *)userId bookId:(NSString *)bookId
{
    NSString *urlString = [[[kMyFriendsWithBookURL stringByAppendingString:bookId] stringByAppendingString:@"/forUser/"] stringByAppendingString:userId];
    return [self buildGetRequestWithRULString:urlString];
}

#pragma mark - private methods

+ (NSMutableURLRequest *)buildRequestWithURLString:(NSString *)urlString bodyDict:(NSDictionary *)bodyDict
{
    NSURL *postURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

+ (NSString *)encrypePassword:(NSString *)password
{
    return [password aes256_encrypt:(NSString *)kPasswordKey];
}

+ (NSMutableURLRequest *)buildRequestWithURLString:(NSString *)requestString bodyDictionary:(NSDictionary *)bodyDictionary HTTPMethod:(NSString *)HTTPMethod
{
    NSURL *postURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    id object = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:HTTPMethod];
    return request;
}

+ (NSMutableURLRequest *)buildGetRequestWithRULString:(NSString *)requestString
{
    NSURL *getURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:getURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    [request setHTTPBody:[NSData data]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    return request;
}

@end
