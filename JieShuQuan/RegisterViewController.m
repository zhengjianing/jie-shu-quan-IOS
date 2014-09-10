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
#import "NSString+AES256.h"
#import "AlertHelper.h"

@implementation RegisterViewController

static const NSString *kRegisterURL = @"http://jie-shu-quan.herokuapp.com/register";
static const NSString *kPasswordKey = @"passwordKey";

- (IBAction)registerUser:(id)sender {
    if (_userName.text.length>0 && _userName.text.length<=20) {
        if ([self isValidateEmail:_email.text]){
            if (_password.text.length>=6 && _password.text.length<=20) {
                if ([_password.text isEqualToString:_confirmPassword.text]) {
                    [_activityIndicatior startAnimating];
                    [self postRequestWithUserName:_userName.text email:_email.text password:_password.text];
                } else [AlertHelper showAlertWithMessage:@"两次输入的密码不一致！" target:self];
            } else [AlertHelper showAlertWithMessage:@"密码长度错误！" target:self];
        } else [AlertHelper showAlertWithMessage:@"邮箱格式错误！" target:self];
    } else [AlertHelper showAlertWithMessage:@"用户名格式错误！" target:self];
}

//正则表达式本地判断email的格式是否正确
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)postRequestWithUserName:(NSString *)name email:(NSString *)email password:(NSString *)password
{
    NSString *encrypedPassword = [password aes256_encrypt:(NSString *)kPasswordKey];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"user_name",
                              email, @"email",
                              encrypedPassword, @"password", nil];
    NSURL *postURL = [NSURL URLWithString:[kRegisterURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    [_activityIndicatior stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:2.0];
}

- (void)dismissAlert:(UIAlertView *)alert
{
    [alert dismissAlertWithObject:self];
}

@end
