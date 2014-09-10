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
    NSString *encrypedPassword = [password aes256_encrypt:(NSString *)kPasswordKey];
    
    NSDictionary *bodyDict = @{@"user_name": userName, @"email": email, @"password": encrypedPassword};
    
    NSURL *registerURL = [NSURL URLWithString:[kRegisterURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:registerURL];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];

    return request;
}

@end
