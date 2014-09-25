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
#import "FormatValidator.h"
#import "RequestBuilder.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    _loginButton.layer.cornerRadius = 5.0;
    _password.delegate = self;
    _email.delegate = self;
    [_email becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginViewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)loginUser:(id)sender {
    [_password resignFirstResponder];
    
    FormatValidator *validator = [[FormatValidator alloc] init];

    if (![validator isValidEmail:_email.text]) {
        [AlertHelper showAlertWithMessage:@"邮箱格式错误！" withAutoDismiss:YES];
        return;
    }
    
    if (![validator isValidPassword:_password.text]) {
        [AlertHelper showAlertWithMessage:@"密码长度错误！" withAutoDismiss:YES];
        return;
    }
    
    [self.activityIndicator startAnimating];
    self.freezeLayer.hidden = NO;
    [self startingLoginWithEmail:_email.text password:_password.text];
}

- (void)startingLoginWithEmail:(NSString *)email password:(NSString *)password
{
    NSMutableURLRequest *loginRequest = [RequestBuilder buildLoginRequestWithEmail:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:loginRequest delegate:self startImmediately:YES];
}

@end