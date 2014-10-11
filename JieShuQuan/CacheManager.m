//
//  CacheManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "CacheManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CacheManager

+ (void)clearAvatarCacheForAvatarURL:(NSString *)url
{
    [[SDImageCache sharedImageCache] removeImageForKey:url];
}

@end
