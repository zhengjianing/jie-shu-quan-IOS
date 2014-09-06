//
//  UserStore.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "UserStore.h"

static const NSString *kCurrentUserName = @"current_username";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";

@implementation UserStore

+ (UserStore *)sharedStore
{
    static UserStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (void)saveCurrentUserByName:(NSString *)userName accessToken:(NSString *)accessToken userId:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserId];
}

- (NSString *)currentUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
}

- (NSString *)currentUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserName];
}

- (void)removeCurrentUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserId];
}

@end
