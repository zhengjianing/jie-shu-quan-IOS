//
//  AuthenticationDelegate.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-10.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "AuthenticationDelegate.h"
#import "BookStore.h"
#import "UserStore.h"
#import "DataConverter.h"
#import "User.h"
#import "UserManager.h"

@interface AuthenticationDelegate ()
{
    NSString *authMethod;
}
@end

@implementation AuthenticationDelegate

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    authMethod = [userObject valueForKey:@"auth_method"];
    
    User *user = [DataConverter userFromObject:userObject];
    [[UserStore sharedStore] saveUserToCoreData:user];
    [UserManager saveUserToUserDefaults:user];
    
    [[BookStore sharedStore] refreshStoredBooks];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", @"connectionDidFinishLoading");
    if ([authMethod isEqualToString:@"login"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:self];
    }
    else if ([authMethod isEqualToString:@"register"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registerSuccess" object:self];
    }
}

@end
