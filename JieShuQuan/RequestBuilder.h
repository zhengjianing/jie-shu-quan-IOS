//
//  RequestBuilder.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

+ (NSMutableURLRequest *)buildRegisterRequestWithUserName:(NSString *)userName email:(NSString *)email password:(NSString *)password;

@end
