//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItem].title = @"更多";
    
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (_userName) {
        [self initViewWithLogin];
    } else {
        [self initViewWithLogout];
    }
}

- (void)initViewWithLogin
{
    _userNameLabel.text = _userName;
    [_loginButton setTitle:@"退出登陆" forState:UIControlStateNormal];
}

- (void)initViewWithLogout
{
    _userNameLabel.text = @"尚未登陆";
    [_loginButton setTitle:@"立即登陆" forState:UIControlStateNormal];
}

- (IBAction)loginLogout:(id)sender {
    if (_userName) {
        [self logout];
    }
}

- (void)logout
{
    [self initViewWithLogout];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
}
@end
