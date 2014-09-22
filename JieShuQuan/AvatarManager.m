//
//  AvatarManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "AvatarManager.h"
#import "ImageHelper.h"

@implementation AvatarManager

static const NSString *kUserAvatarImageName = @"userAvatar";
static const NSString *kDefautLoginImageName = @"log-in-user.png";
static const NSString *kDefautLogoutImageName = @"log-out-user.png";

+ (UIImage *)avatarForUserId:(NSString *)userId
{
    NSString *userAvatarImagePath = [ImageHelper pathForImageName:(NSString *)[self avatarImageNameForUserId:userId]];
    UIImage *userAvatarImage = [UIImage imageWithContentsOfFile:userAvatarImagePath];
    if (userAvatarImage) {
        return userAvatarImage;
    }
    return [UIImage imageNamed:(NSString *)kDefautLogoutImageName];
}

+ (NSString *)avatarImageNameForUserId:(NSString *)userId
{
    return [NSString stringWithFormat:@"%@-%@.png", (NSString *)kUserAvatarImageName, userId];
}

+ (UIImage *)logoutAvatar
{
    return [UIImage imageNamed:(NSString *)kDefautLogoutImageName];
}

@end
