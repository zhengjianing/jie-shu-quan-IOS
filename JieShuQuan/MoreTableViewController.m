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
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "SettingsTableViewController.h"
#import "MailManager.h"
#import "MobClick.h"
#import <FontAwesomeKit/FAKIonIcons.h>

static const NSString *kDefaultCount = @"--";
static const NSString *kDefaultUserName = @"点击设置用户名";

@implementation MoreTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FAKIcon *icon = [FAKIonIcons chevronRightIconWithSize:10];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIImage *arrowImage = [icon imageWithSize:CGSizeMake(15, 15)];
    [_arrowIconImageView setImage:arrowImage];
    
    [AvatarManager setAvatarStyleForImageView:_userIconImageView];
    [self setTableFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self configureView];
    
    [MobClick beginLogPageView:@"morePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"morePage"];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)configureView
{
    if ([UserManager isLogin]) {
        [self updateViewForLogin];
    } else {
        [self updateViewForLogout];
    }
}

- (void)updateViewForLogin
{
    User *currentUser = [UserManager currentUser];
    NSURL *avatarURL = [NSURL URLWithString:currentUser.avatarURLString];
    [_userIconImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];

    [_pleaseLoginLabel setHidden:YES];
    [_userNameLabel setHidden:NO];
    [_emailLabel setHidden:NO];
    [_locationLabel setHidden:NO];
    _userNameLabel.text = currentUser.userName;
    _userNameLabel.textColor = [UIColor whiteColor];

    if ([_userNameLabel.text isEqualToString:@""]) {
        _userNameLabel.text = (NSString *)kDefaultUserName;
        _userNameLabel.textColor = [UIColor colorWithRed:242/255.0 green:87/255.0 blue:45/255.0 alpha:1];
    }
    _emailLabel.text = currentUser.userEmail;
    _locationLabel.text = currentUser.location;
    
    _bookCountLabel.text = currentUser.bookCount;
    _friendsCountLabel.text = currentUser.friendCount;
    
    [_logoutCell setUserInteractionEnabled:YES];
    _logoutLabel.textColor = [UIColor blackColor];
}

- (void)updateViewForLogout
{
    [_userIconImageView setImage:[AvatarManager logoutAvatar]];
    [_pleaseLoginLabel setHidden:NO];
    [_userNameLabel setHidden:YES];
    [_emailLabel setHidden:YES];
    [_locationLabel setHidden:YES];

    _bookCountLabel.text = (NSString *)kDefaultCount;
    _friendsCountLabel.text = (NSString *)kDefaultCount;
    
    [_logoutCell setUserInteractionEnabled:NO];
    _logoutLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        [MobClick event:@"setUserInfoCellPressed"];

        [self showSettingsOrLoginView];
        return;
    }
    
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        [MobClick event:@"weChatCellPressed"];
        
        return;
    }
    
    if ([indexPath section] == 1 && [indexPath row] == 1) {
        [MobClick event:@"aboutCellPressed"];
        
        return;
    }
    
    if ([indexPath section] == 1 && [indexPath row] == 2) {
        [MobClick event:@"feedbackCellPressed"];

        [self sendFeedbackWithMailView];
        return;
    }
    
    if ([indexPath section] == 2 && [indexPath row] == 0) {
        [MobClick event:@"logoutCellPressed"];

        [[ActionSheetHelper actionSheetWithTitle:@"确认退出吗？" delegate:self] showInView:self.view];
        return;
    }
}

- (void)showSettingsOrLoginView
{
    id targetViewController;
    if ([UserManager isLogin]) {
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
    } else {
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (void)sendFeedbackWithMailView
{
    NSString *toEmailAddress = @"jieshuquan@test.com";
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        [MailManager displayComposerSheetToEmailAddress:toEmailAddress delegate:self];
    } else {
        [MailManager launchMailToEmailAddress:toEmailAddress];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
