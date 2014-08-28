//
//  JsonDataFetcher.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDataFetcher : NSObject

+ (void)dataFromURL:(NSURL *)url withCompletion:(void (^)(NSData *jsonData))completionBlock;

@end
