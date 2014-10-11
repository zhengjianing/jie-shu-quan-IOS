//
//  User.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userEmail;
@property (copy, nonatomic) NSString *avatarURLString;
@property (copy, nonatomic) NSString *bookCount;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *friendCount;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *phoneNumber;

@end
