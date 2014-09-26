//
//  Friend.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (copy, nonatomic) NSString *friendId;
@property (copy, nonatomic) NSString *friendName;
@property (copy, nonatomic) NSString *friendEmail;
@property (copy, nonatomic) NSString *friendLocation;
@property (copy, nonatomic) NSString *bookCount;

@end
