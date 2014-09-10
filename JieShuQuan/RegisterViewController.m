//
//  RegisterViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "AlertHelper.h"
#import "Validator.h"
#import "RequestBuilder.h"
#import "AuthenticationDelegate.h"

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:@"registerSuccess" object:nil];
}

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
    [self startingRegisterWithUserName:_userName.text email:_email.text password:_password.text];
}

- (IBAction)emailHint:(id)sender {
    [AlertHelper showAlertWithMessage:@"请使用企业邮箱！\n若使用个人邮箱，则无法添加到分组" target:self];
}

- (void)startingRegisterWithUserName:(NSString *)name email:(NSString *)email password:(NSString *)password
{    
    _authDelegate = [[AuthenticationDelegate alloc] init];
    NSMutableURLRequest *registerRequest = [RequestBuilder buildRegisterRequestWithUserName:name email:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:registerRequest delegate:_authDelegate startImmediately:YES];
}

- (void)registerSuccess
{
    [_activityIndicatior stopAnimating];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
