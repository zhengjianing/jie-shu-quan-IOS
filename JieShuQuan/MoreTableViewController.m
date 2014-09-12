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

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"userInfoCell.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_userInfoCell.backgroundView.frame];
    [imageView setImage:backgroundImage];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2) {
        [UserManager removeUserFromUserDefaults];
        [self updateViewForLogout];
    }
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
    _bookCountLabel.text = @"0";
    _friendsCountLabel.text = @"0";

    _userNameButton.titleLabel.text = @"立即登录";
    [_userNameButton setUserInteractionEnabled:YES];
    
    [_logoutCell setUserInteractionEnabled:NO];
    _logoutLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

@end
