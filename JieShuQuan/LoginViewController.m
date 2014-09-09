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
#import "NSString+AES256.h"
#import "AlertHelper.h"
#import "RegisterViewController.h"

static const NSString *kLoginURL = @"http://jie-shu-quan.herokuapp.com/login";
static const NSString *kPasswordKey = @"passwordKey";

@implementation LoginViewController


- (IBAction)recoverPassword:(id)sender {
}

- (IBAction)loginUser:(id)sender {
    if ([self isValidateEmail:_email.text]){
        if (_password.text.length>=6 && _password.text.length<=20) {
            [self postRequestWithEmail:_email.text password:_password.text];
        } else [AlertHelper showAlertWithMessage:@"密码长度错误！" target:self];
    } else [AlertHelper showAlertWithMessage:@"邮箱格式错误！" target:self];
}


//正则表达式本地判断email的格式是否正确
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)postRequestWithEmail:(NSString *)email password:(NSString *)password
{
    NSString *encrypedPassword = [password aes256_encrypt:(NSString *)kPasswordKey];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              email, @"email",
                              encrypedPassword, @"password", nil];
    NSURL *postURL = [NSURL URLWithString:[kLoginURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
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
    [AlertHelper showAlertWithMessage:@"登陆成功，返回我的书" target:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
