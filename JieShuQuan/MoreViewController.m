//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "UserManager.h"
#import "User.h"

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserManager isLogin]) {
        [self updateViewWithLogin];
    } else {
        [self updateViewWithLogout];
    }
}

- (void)updateViewWithLogin
{
    _userNameLabel.text = [[UserManager currentUser] userName];
    [_loginButton setTitle:@"退出登录" forState:UIControlStateNormal];
}

- (void)updateViewWithLogout
{
    _userNameLabel.text = @"请登录";
    [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([_loginButton.titleLabel.text isEqualToString:@"退出登录"]) {
        [UserManager removeUserFromUserDefaults];
    }
}

@end
