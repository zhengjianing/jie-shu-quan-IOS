//
//  JsonDataFetcher.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "JsonDataFetcher.h"

@implementation JsonDataFetcher

+ (void)dataFromURL:(NSURL *)url withCompletion:(void (^)(NSData *jsonData))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                completionBlock(data);
            } else {
                NSLog(@"Data Fetching failed...");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"webDataFetchFailed" object:self];
//                abort();
            }
        });
    });
}

@end
