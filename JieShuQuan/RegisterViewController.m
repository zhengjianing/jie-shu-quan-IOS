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
#import "Validator.h"

@implementation RegisterViewController

static const NSString *kRegisterURL = @"http://jie-shu-quan.herokuapp.com/register";
static const NSString *kPasswordKey = @"passwordKey";

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
    [self postRequestWithUserName:_userName.text email:_email.text password:_password.text];
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
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:2.0];
}

- (void)dismissAlert:(UIAlertView *)alert
{
    [alert dismissAlertWithObject:self];
}



@end
