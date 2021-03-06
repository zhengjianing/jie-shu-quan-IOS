//
//  AvatarManager.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AvatarManager : NSObject

+ (UIImage *)logoutAvatar;
+ (UIImage *)defaulFriendAvatar;

+ (void)setAvatarStyleForImageView:(UIImageView *)imageView;

+ (void)saveImage:(UIImage *)image withUserId:(NSString *)userId;
+ (NSString *)avatarPathForUserId:(NSString *)userId;

+ (NSString *)updateAvatarURLStringForUserId:(NSString *)userId;

@end
