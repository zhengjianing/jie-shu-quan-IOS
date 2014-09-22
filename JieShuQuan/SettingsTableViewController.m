//
//  SettingsTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserManager.h"
#import "User.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initViewWithCurrentUser];
}

- (void)initViewWithCurrentUser
{
    User *currentUser = [UserManager currentUser];
    _userNameLabel.text = currentUser.userName;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil] showInView:self.view];
                
                break;
            case 1:
                NSLog(@"--- 0 1 ---");
                break;
                
            default:
                break;
        }
        return;
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                NSLog(@"--- 1 0 ---");
                break;
            case 1:
                NSLog(@"--- 1 1 ---");
                break;
            case 2:
                NSLog(@"--- 1 2 ---");
                break;
                
            default:
                break;
        }
        return;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"拍照");
            break;
        case 1:
            NSLog(@"相册");
            break;
                    
        default:
            break;
    }
}


@end
