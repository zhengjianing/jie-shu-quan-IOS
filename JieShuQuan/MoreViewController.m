//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "UserStore.h"

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItem].title = @"更多";
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)viewWillAppear:(BOOL)animated
{
    _userName = [[UserStore sharedStore] currentUserName];
    if (_userName) {
        [self updateViewWithLogin];
    } else {
        [self updateViewWithLogout];
    }
}

- (void)updateViewWithLogin
{
    _userNameLabel.text = _userName;
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
        _userName = nil;
        [[UserStore sharedStore] removeCurrentUserFromUD];
    }
}

@end
