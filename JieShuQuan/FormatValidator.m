//
//  Validator.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FormatValidator.h"

@implementation FormatValidator

- (BOOL)isValidUserName:(NSString *)userName
{
    return (userName.length > 0 && userName.length <= 20);
}

- (BOOL)isValidEmail:(NSString *)emailAdress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAdress];
}

- (BOOL)isValidPassword:(NSString *)password
{
    return (password.length >= 6 && password.length <= 20);
}

- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    NSString *validValue = @"[0-9]{11}";
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validValue];
    return [predict evaluateWithObject:phoneNumber];
}

@end
