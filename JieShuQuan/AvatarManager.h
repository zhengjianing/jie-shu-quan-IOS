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

+ (UIImage *)avatarForUserId:(NSString *)userId;
+ (NSString *)avatarImageNameForUserId:(NSString *)userId;
+ (UIImage *)logoutAvatar;
+ (void)setAvatarStyleForImageView:(UIImageView *)imageView;

@end
