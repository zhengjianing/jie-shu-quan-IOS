//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-9.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "LoginViewController.h"
#import "AlertHelper.h"
#import "RegisterViewController.h"
#import "Validator.h"
#import "RequestBuilder.h"
#import "AuthenticationDelegate.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
}

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
    _authDelegate = [[AuthenticationDelegate alloc] init];
    NSMutableURLRequest *loginRequest = [RequestBuilder buildLoginRequestWithEmail:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:loginRequest delegate:_authDelegate startImmediately:YES];
}

- (void)loginSuccess
{
    [_activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end