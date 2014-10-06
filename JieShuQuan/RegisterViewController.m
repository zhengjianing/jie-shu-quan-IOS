//
//  RegisterViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "AlertHelper.h"
#import "FormatValidator.h"
#import "RequestBuilder.h"
#import "CustomAlert.h"
#import "CustomActivityIndicator.h"

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _registerButton.layer.cornerRadius = 5.0;
    _email.delegate = self;
    _password.delegate = self;
    _confirmPassword.delegate = self;
    [_email becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)registerViewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)registerUser:(id)sender {
    [_confirmPassword resignFirstResponder];

    FormatValidator *validator = [[FormatValidator alloc] init];
    if (![validator isValidEmail:_email.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"邮箱格式错误"];

        return;
    }
    
    if (![validator isValidPassword:_password.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"密码长度错误"];

        return;
    }
    
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"两次输入的密码不一致"];

        return;
    }
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self startingRegisterWithEmail:_email.text password:_password.text];
}

- (void)startingRegisterWithEmail:(NSString *)email password:(NSString *)password
{    
    NSMutableURLRequest *registerRequest = [RequestBuilder buildRegisterRequestWithEmail:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:registerRequest delegate:self startImmediately:YES];
}

@end
