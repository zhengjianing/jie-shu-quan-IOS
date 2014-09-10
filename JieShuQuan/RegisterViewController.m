//
//  RegisterViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "BookStore.h"
#import "UserStore.h"
#import "AlertHelper.h"
#import "Validator.h"
#import "RequestBuilder.h"

@implementation RegisterViewController

- (IBAction)registerUser:(id)sender {
    Validator *validator = [[Validator alloc] init];
    
    if (![validator isValidUserName:_userName.text]) {
        [AlertHelper showAlertWithMessage:@"用户名格式错误！" target:self];
        return;
    }
    
    if (![validator isValidEmail:_email.text]) {
        [AlertHelper showAlertWithMessage:@"邮箱格式错误！" target:self];
        return;
    }
    
    if (![validator isValidPassword:_password.text]) {
        [AlertHelper showAlertWithMessage:@"密码长度错误！" target:self];
        return;
    }
    
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [AlertHelper showAlertWithMessage:@"两次输入的密码不一致！" target:self];
        return;
    }
    
    [_activityIndicatior startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [self startingRegisterWithUserName:_userName.text email:_email.text password:_password.text];
}

- (void)startingRegisterWithUserName:(NSString *)name email:(NSString *)email password:(NSString *)password
{    
    NSMutableURLRequest *registerRequest = [RequestBuilder buildRegisterRequestWithUserName:name email:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:registerRequest delegate:self startImmediately:YES];
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
    [_activityIndicatior stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
