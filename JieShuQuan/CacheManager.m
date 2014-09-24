//
//  CacheManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "CacheManager.h"
#import "AvatarManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CacheManager

+ (void)clearAvatarCacheForUserIds:(NSMutableArray *)userIds
{
    for (NSString *userId in userIds) {
        [self clearAvatarCacheForUserId:userId];
    }
}

+ (void)clearAvatarCacheForUserId:(NSString *)userId
{
    [[SDImageCache sharedImageCache] removeImageForKey:[AvatarManager avatarURLStringForUserId:userId]];
}

@end
