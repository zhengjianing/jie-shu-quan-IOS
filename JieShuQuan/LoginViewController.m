//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-9.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "LoginViewController.h"
#import "BookStore.h"
#import "UserStore.h"
#import "AlertHelper.h"
#import "RegisterViewController.h"
#import "Validator.h"
#import "RequestBuilder.h"

static const NSString *kPasswordKey = @"passwordKey";

@implementation LoginViewController

- (IBAction)recoverPassword:(id)sender {
}

- (IBAction)loginUser:(id)sender {
    Validator *validator = [[Validator alloc] init];

    if (![validator isValidEmail:_email.text]) {
        [AlertHelper showAlertWithMessage:@"邮箱格式错误！" target:self];
        return;
    }
    
    if (![validator isValidPassword:_password.text]) {
        [AlertHelper showAlertWithMessage:@"密码长度错误！" target:self];
        return;
    }
    
    [_activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [self startingLoginWithEmail:_email.text password:_password.text];
}

- (void)startingLoginWithEmail:(NSString *)email password:(NSString *)password
{
    NSMutableURLRequest *loginRequest = [RequestBuilder buildLoginRequestWithEmail:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:loginRequest delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", userObject);
    [[UserStore sharedStore] saveCurrentUserToUDAndDBByUserObject:userObject];
    [[BookStore sharedStore] refreshStoredBooks];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", @"connectionDidFinishLoading");
    [_activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end