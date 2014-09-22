//
//  MoreTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/12/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MoreTableViewController.h"
#import "UserManager.h"
#import "User.h"
#import "ActionSheetHelper.h"
#import "AvatarManager.h"

static const NSString *kDefaultCount = @"0";

@implementation MoreTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AvatarManager setAvatarStyleForImageView:_userIconImageView];
    [self setUserInfoBackgroundImage];
    [self setTableFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self configureView];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)setUserInfoBackgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_userInfoCell.backgroundView.frame];
    [imageView setImage:[UIImage imageNamed:@"bg.jpeg"]];
    self.userInfoCell.backgroundView = imageView;
}

- (void)configureView
{
    if ([UserManager isLogin]) {
        [self updateViewForLogin];
    } else {
        [self updateViewForLogout];
    }
}

#pragma mark - Logout & Login

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2) {
        [[ActionSheetHelper actionSheetWithTitle:@"确认退出吗？" delegate:self] showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self confirmedLogout];
    }
}

- (void)confirmedLogout
{
    [UserManager removeUserFromUserDefaults];
    [self updateViewForLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetSearch" object:self];
}

- (void)updateViewForLogin
{
    [_settingsButton setEnabled:YES];
    [_userIconImageView setImage:[AvatarManager avatarForUserId:[[UserManager currentUser] userId]]];
    
    _bookCountLabel.text = [[UserManager currentUser] bookCount];
    _friendsCountLabel.text = [[UserManager currentUser] friendCount];

    [_userNameButton setTitle:[[UserManager currentUser] userName] forState:UIControlStateNormal];
    [_userNameButton setUserInteractionEnabled:NO];
    
    [_logoutCell setUserInteractionEnabled:YES];
    _logoutLabel.textColor = [UIColor blackColor];
}

- (void)updateViewForLogout
{
    [_settingsButton setEnabled:NO];
    [_userIconImageView setImage:[AvatarManager logoutAvatar]];
    
    _bookCountLabel.text = (NSString *)kDefaultCount;
    _friendsCountLabel.text = (NSString *)kDefaultCount;

    [_userNameButton setTitle:@"立即登录" forState:UIControlStateNormal];

    [_userNameButton setUserInteractionEnabled:YES];
    
    [_logoutCell setUserInteractionEnabled:NO];
    _logoutLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

@end
