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

- (void)saveCurrentUserToUDAndDBByUserObject:(id)userObject;
- (NSString *)currentUserId;
- (NSString *)currentUserName;
- (void)removeCurrentUserFromUD;
- (NSArray *)storedUsersByUserId:(NSString *)userId;

@end
