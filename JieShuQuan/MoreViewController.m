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

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItem].title = @"更多";
    
    UIStoryboard *mainStoryboard = self.storyboard;
    
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];
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
    _userNameLabel.text = @"请用您的豆瓣账号登录";
    [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
}

- (IBAction)loginLogout:(id)sender {
    if (_userName) {
        [self logout];
    } else {
        [self login];
    }
}

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
    
    [self updateViewWithLogin];
}

- (void)logout
{
    _userName = nil;
    [[UserStore sharedStore] removeCurrentUser];
    
    [self updateViewWithLogout];
}
@end
