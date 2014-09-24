//
//  AvatarManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "AvatarManager.h"
#import "ServerHeaders.h"

@implementation AvatarManager

static const NSString *kUserAvatarImageName = @"userAvatar";
static const NSString *kDefautLoginImageName = @"log-in-user.png";
static const NSString *kDefautLogoutImageName = @"log-out-user.png";

+ (UIImage *)avatarForUserId:(NSString *)userId
{
    NSString *userAvatarImagePath = [self avatarPathForUserId:userId];
    UIImage *userAvatarImage = [UIImage imageWithContentsOfFile:userAvatarImagePath];
    if (userAvatarImage) {
        return userAvatarImage;
    }
    return [UIImage imageNamed:(NSString *)kDefautLoginImageName];
}

+ (NSURL *)avatarURLForUserId:(NSString *)userId
{
    NSString *friendAvatarUrl = [NSString stringWithFormat:@"%@-%@.png", kAvatarURLPrefix, userId];
    return [NSURL URLWithString:friendAvatarUrl];
}

+ (UIImage *)logoutAvatar
{
    return [UIImage imageNamed:(NSString *)kDefautLogoutImageName];
}

+ (UIImage *)defaulFriendAvatar
{
    return [UIImage imageNamed:(NSString *)kDefautLoginImageName];
}

+ (void)setAvatarStyleForImageView:(UIImageView *)imageView
{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth = 0.5;
}

+ (void)saveImage:(UIImage *)image withUserId:(NSString *)userId
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[self avatarImageNameForUserId:userId]];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (NSString *)avatarPathForUserId:(NSString *)userId
{
    return [self pathForImageName:(NSString *)[self avatarImageNameForUserId:userId]];;
}

#pragma mark - private methods

+ (NSString *)avatarImageNameForUserId:(NSString *)userId
{
    return [NSString stringWithFormat:@"%@-%@.png", (NSString *)kUserAvatarImageName, userId];
}

+ (NSString *)pathForImageName:(NSString *)imageName
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
}

@end
