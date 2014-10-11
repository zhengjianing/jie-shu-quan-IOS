//
//  CacheManager.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (void)clearAvatarCacheForAvatarURL:(NSString *)url;

@end
