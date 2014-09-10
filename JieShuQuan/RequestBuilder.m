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
@end
