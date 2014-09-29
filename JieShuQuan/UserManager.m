//
//  UserManager.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
#import "UserStore.h"

static const NSString *kUDCurrentUserId = @"current_user_id";

@implementation UserManager

+ (void)saveUserToUserDefaults:(User *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:(NSString *)kUDCurrentUserId];
}

+ (User *)currentUser
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDCurrentUserId];
    return (userId == nil) ? nil : [[UserStore sharedStore] userWithUserId:userId];
}

+ (void)removeUserFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDCurrentUserId];
}

+ (BOOL)isLogin
{
    return ([self currentUser] == nil) ? NO : YES;
}

@end
