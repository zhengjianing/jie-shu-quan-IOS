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

static const NSString *kDefaultCount = @"0";

@implementation MoreTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUserInfoBackgroundImage];
}

- (void)setUserInfoBackgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_userInfoCell.backgroundView.frame];
    [imageView setImage:[UIImage imageNamed:@"userInfoCell.jpg"]];
    self.userInfoCell.backgroundView = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
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
        UIActionSheet *confirmLogoutActionSheet = [[UIActionSheet alloc] initWithTitle:@"确认退出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [confirmLogoutActionSheet showInView:self.view];
    }
}

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
}

- (void)updateViewForLogin
{
    _bookCountLabel.text = [[UserManager currentUser] bookCount];
    _friendsCountLabel.text = [[UserManager currentUser] friendCount];

    _userNameButton.titleLabel.text = [[UserManager currentUser] userName];
    [_userNameButton setUserInteractionEnabled:NO];
    
    [_logoutCell setUserInteractionEnabled:YES];
    _logoutLabel.textColor = [UIColor blackColor];
}

- (void)updateViewForLogout
{
    _bookCountLabel.text = (NSString *)kDefaultCount;
    _friendsCountLabel.text = (NSString *)kDefaultCount;

    _userNameButton.titleLabel.text = @"立即登录";
    [_userNameButton setUserInteractionEnabled:YES];
    
    [_logoutCell setUserInteractionEnabled:NO];
    _logoutLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

@end
