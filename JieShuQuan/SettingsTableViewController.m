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
#import "ImageHelper.h"
#import "AvatarManager.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *userAvatarImage;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [AvatarManager setAvatarStyleForImageView:_userAvatarImageView];
    [self initViewWithCurrentUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initViewWithCurrentUser
{
    User *currentUser = [UserManager currentUser];

    [_userAvatarImageView setImage:[AvatarManager avatarForUserId:[currentUser userId]]];
    _userNameLabel.text = currentUser.userName;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self changeUserAvatar];
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

#pragma mark - Change User Avatar

- (void)changeUserAvatar
{
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil] showInView:self.view];
}

- (void)takePhotoFromCamera
{
    [self createImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)pickImageFromAlbum
{
    [self createImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)createImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = sourceType;
    _imagePicker.delegate = (id)self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)refreshUserAvatar
{
    [_userAvatarImageView setImage:_userAvatarImage];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhotoFromCamera];
            break;
        case 1:
            [self pickImageFromAlbum];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    _userAvatarImage = [ImageHelper scaleImage:image toSize:CGSizeMake(120.0, 120.0)];
    [ImageHelper saveImage:_userAvatarImage withName:[AvatarManager avatarImageNameForUserId:[[UserManager currentUser] userId]]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self refreshUserAvatar];
}

@end