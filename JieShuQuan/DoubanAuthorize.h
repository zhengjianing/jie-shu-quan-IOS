//
//  DoubanAuthorize.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubanRequest.h"


@interface DoubanAuthorize : NSObject

@property (strong, nonatomic) DoubanRequest *req;

- (NSMutableURLRequest *)startAuthorize;
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code;

@end
