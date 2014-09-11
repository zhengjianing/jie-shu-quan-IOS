//
//  UserManager.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "UserManager.h"
#import "User.h"

// keys in NSUserDefaults
static const NSString *kUDCurrentUser = @"current_user";

@implementation UserManager

+ (void)saveUserToUserDefaults:(User *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:(NSString *)kUDCurrentUser];
}

+ (User *)currentUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDCurrentUser];
}

+ (void)removeUserFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDCurrentUser];
}

+ (BOOL)isLogin
{
    return [self currentUser] == nil ? NO : YES;
}


@end
