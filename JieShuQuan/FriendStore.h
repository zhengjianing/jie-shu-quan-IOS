//
//  FriendStore.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@class Friend;

@interface FriendStore : Store

+ (FriendStore *)sharedStore;

- (NSArray *)storedFriends;
- (void)refreshStoredFriends;

- (void)addFriendToStore:(Friend *)friend;
- (void)emptyFriendStoreForCurrentUser;

@end
