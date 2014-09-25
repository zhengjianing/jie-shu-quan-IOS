//
//  Comment.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *book_id;
@property (copy, nonatomic) NSString *user_name;

@end
