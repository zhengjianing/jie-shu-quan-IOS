//
//  UserManager.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserManager : NSObject

+ (void)saveUserToUserDefaults:(User *)user;
+ (User *)currentUser;
+ (BOOL)isLogin;
+ (void)removeUserFromUserDefaults;

@end
