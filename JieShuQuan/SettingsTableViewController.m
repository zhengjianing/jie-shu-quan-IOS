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
#import "RequestBuilder.h"
#import "CustomActivityIndicator.h"
#import "ServerHeaders.h"
#import "ASIFormDataRequest.h"
#import "ChangeNameViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CacheManager.h"
#import "ProvinceTableViewController.h"
#import "ChangePhoneNumberViewController.h"
#import "CustomAlert.h"
#import "MobClick.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLocation;
@property (strong, nonatomic) IBOutlet UILabel *userPhoneNumber;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSURL *avatarURL;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableFooterView];
    [AvatarManager setAvatarStyleForImageView:_userAvatarImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initViewWithCurrentUser];
    self.tabBarController.tabBar.hidden = YES;
    
    [MobClick beginLogPageView:@"settingsPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"settingsPage"];
}

- (void)initViewWithCurrentUser
{
    _currentUser = [UserManager currentUser];
    _avatarURL = [AvatarManager avatarURLForUserId:_currentUser.userId];
    [_userAvatarImageView sd_setImageWithURL:_avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    _userNameLabel.text = _currentUser.userName;
    _userLocation.text = _currentUser.location;
    _userPhoneNumber.text = _currentUser.phoneNumber;
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        [MobClick event:@"changeAvatarCellPressed"];

        [self changeUserAvatar];
        return;
    }
    
    if ([indexPath section] == 0 && [indexPath row] == 1) {
        [MobClick event:@"changeUsernameCellPressed"];
        
        return;
    }
    
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        [MobClick event:@"changeCityCellPressed"];
        
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

- (void)startingUploadAvatar
{
    NSURL *postURL = [NSURL URLWithString:[kUploadAvatarURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:postURL];

    [request addPostValue:_currentUser.userId forKey:@"user_id"];
    [request addPostValue:_currentUser.accessToken forKey:@"access_token"];

    NSString *avatarPath = [AvatarManager avatarPathForUserId:_currentUser.userId];
    [request setFile:avatarPath forKey:@"avatar_file"];
    
    [request buildPostBody];
    [request setTimeOutSeconds:5];

    [request setDidReceiveDataSelector:@selector(requestDidReceiveData:)];
    [request setDidFailSelector:@selector(requestDidFail:)];

    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)refreshUserAvatar
{
    [CacheManager clearAvatarCacheForUserId:_currentUser.userId];
    [_userAvatarImageView sd_setImageWithURL:_avatarURL placeholderImage:_avatar];
}

- (void)saveAvatarToSandbox
{
    [AvatarManager saveImage:_avatar withUserId:_currentUser.userId];
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
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    
    _avatar = [ImageHelper scaleImage:originalImage toSize:CGSizeMake(120.0, 120.0)];
    
    [self saveAvatarToSandbox];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    [self startingUploadAvatar];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestDidReceiveData:(ASIFormDataRequest *)request
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];

    if ([request responseStatusCode] != 200) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"上传头像失败"];
        return;
    }
    [[CustomAlert sharedAlert] showAlertWithMessage:@"上传头像成功"];
    [self refreshUserAvatar];
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [[CustomAlert sharedAlert] showAlertWithMessage:@"上传头像失败"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ChangeNameViewController class]]) {
        [segue.destinationViewController setNameString:_currentUser.userName];
        return;
    }
    if ([segue.destinationViewController isKindOfClass:[ProvinceTableViewController class]]) {
        [segue.destinationViewController setOldLocation:_userLocation.text];
    }
    if ([segue.destinationViewController isKindOfClass:[ChangePhoneNumberViewController class]]) {
        [segue.destinationViewController setNumberString:_userPhoneNumber.text];
    }
}

@end
