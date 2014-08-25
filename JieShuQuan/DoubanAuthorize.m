//
//  DoubanAuthorize.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "DoubanAuthorize.h"
#import "DoubanHeaders.h"
#import "DoubanRequest.h"

@implementation DoubanAuthorize

- (id)init
{
    self = [super init];
    if (self)
    {
        _req = [[DoubanRequest alloc] init];
    }
    return self;
}

- (NSMutableURLRequest *)startAuthorize
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kAPIKey, @"client_id",
                            kRedirect_URL, @"redirect_uri",
                            @"code", @"response_type",
                            nil];
    NSString *urlString = [DoubanRequest serializeURL:kAuthorizeURL
                                           withParams:params];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    return [NSMutableURLRequest requestWithURL:requestURL];
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kAPIKey, @"client_id",
                            kSecret, @"client_secret",
                            kRedirect_URL, @"redirect_uri",
                            @"authorization_code", @"grant_type",
                            code, @"code",
                            nil];
    _req = [DoubanRequest requestWithURL:kTokenURL
                              withParams:params];
    [_req connect];
}

@end
