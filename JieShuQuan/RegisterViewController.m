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
    
    FormatValidator *validator = [[FormatValidator alloc] init];
    if (![validator isValidEmail:_email.text]) {
        [AlertHelper showAlertWithMessage:@"邮箱格式错误！" withAutoDismiss:YES];
        return;
    }
    
    if (![validator isValidPassword:_password.text]) {
        [AlertHelper showAlertWithMessage:@"密码长度错误！" withAutoDismiss:YES];
        return;
    }
    
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [AlertHelper showAlertWithMessage:@"两次输入的密码不一致！" withAutoDismiss:YES];
        return;
    }
    
    [self.activityIndicator startAnimating];
    self.freezeLayer.hidden = NO;
    [self startingRegisterWithEmail:_email.text password:_password.text];
}

- (IBAction)emailHint:(id)sender {
    [AlertHelper showAlertWithMessage:@"使用企业邮箱，便于我们帮您找到您的朋友们" withAutoDismiss:NO];
}

- (void)startingRegisterWithEmail:(NSString *)email password:(NSString *)password
{    
    NSMutableURLRequest *registerRequest = [RequestBuilder buildRegisterRequestWithEmail:email password:password];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:registerRequest delegate:self startImmediately:YES];
}

@end
