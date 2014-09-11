//
//  Validator.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatValidator : NSObject

- (BOOL)isValidUserName:(NSString *)userName;
- (BOOL)isValidEmail:(NSString *)emailAdress;
- (BOOL)isValidPassword:(NSString *)password;

@end
