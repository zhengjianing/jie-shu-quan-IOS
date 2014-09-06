//
//  UserStore.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStore : NSObject

+ (UserStore *)sharedStore;
- (void)saveCurrentUserByName:(NSString *)userName accessToken:(NSString *)accessToken userId:(NSString *)userID;
- (NSString *)currentUserId;
- (NSString *)currentUserName;
- (void)removeCurrentUser;

@end
