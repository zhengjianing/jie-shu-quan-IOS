//
//  DoubanRequest.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoubanRequest : NSObject <NSURLConnectionDataDelegate>

+ (NSString *)serializeURL:(NSString *)baseURL withParams:(NSDictionary *)params;

+ (DoubanRequest *)requestWithURL:(NSString *)url withParams:(NSDictionary *)params;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *params;

- (void)connect;

@end
