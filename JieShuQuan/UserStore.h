//
//  UserStore.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
@class User;
@interface UserStore : Store

+ (UserStore *)sharedStore;

- (void)saveUserToCoreData:(User *)user;
- (NSArray *)storedUsersWithUserId:(NSString *)userId;

@end
