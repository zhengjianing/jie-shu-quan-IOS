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

@implementation RequestBuilder

static const NSString *kPasswordKey = @"passwordKey";
static const NSString *kBookId = @"douban_book_id";
static const NSString *kAvailableState = @"available";

+ (NSMutableURLRequest *)buildRegisterRequestWithUserName:(NSString *)userName email:(NSString *)email password:(NSString *)password
{
    NSDictionary *registerBody = @{@"user_name": userName, @"email": email, @"password": [self encrypePassword:password]};
    
    return [self buildRequestWithURLString:kRegisterURL bodyDict:registerBody];
}

+ (NSMutableURLRequest *)buildLoginRequestWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *loginBody = @{@"email": email, @"password": [self encrypePassword:password]};
    
    return [self buildRequestWithURLString:kLoginURL bodyDict:loginBody];
}

+ (NSMutableURLRequest *)buildRequestWithURLString:(NSString *)urlString bodyDict:(NSDictionary *)bodyDict
{
    NSURL *postURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
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

+ (NSMutableURLRequest *)buildAddBookRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    
    
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
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    return [self buildRequestWithURLString:kChangeBookStatusURL bodyDictionary:bodyDict HTTPMethod:@"PUT"];
}

+ (NSMutableURLRequest *)buildFetchBooksRequestForUserId:(NSString *)userId
{
    NSString *getString = [kMyBooksURL stringByAppendingString:userId];
    NSURL *getURL = [NSURL URLWithString:[getString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:getURL];
    
    [request setHTTPBody:[NSData data]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    return request;
}

#pragma mark -- private methods

+ (NSMutableURLRequest *)buildRequestWithURLString:(NSString *)requestString bodyDictionary:(NSDictionary *)bodyDictionary HTTPMethod:(NSString *)HTTPMethod
{
    NSURL *postURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    id object = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:HTTPMethod];
    return request;
}


@end
