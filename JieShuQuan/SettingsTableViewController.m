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
#import "AlertHelper.h"
#import "RequestBuilder.h"
#import "CustomActivityIndicator.h"
#import "ServerHeaders.h"
#import "ASIFormDataRequest.h"
#import "ChangeNameViewController.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) User *currentUser;

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableFooterView];
    [self.tableView addSubview:self.activityIndicator];

    [AvatarManager setAvatarStyleForImageView:_userAvatarImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initViewWithCurrentUser];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initViewWithCurrentUser
{
    _currentUser = [UserManager currentUser];

    [_userAvatarImageView setImage:[AvatarManager avatarForUserId:[_currentUser userId]]];
    _userNameLabel.text = _currentUser.userName;
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
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
    [_userAvatarImageView setImage:_avatar];
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
    [self refreshUserAvatar];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_activityIndicator startAnimating];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [self startingUploadAvatar];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestDidReceiveData:(ASIFormDataRequest *)request
{
    [_activityIndicator stopAnimating];
    [self.navigationItem setHidesBackButton:NO animated:YES];

    if ([request responseStatusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"上传头像失败" withAutoDismiss:YES];
        return;
    }
    
    [AlertHelper showAlertWithMessage:@"上传头像成功" withAutoDismiss:YES];
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    [_activityIndicator stopAnimating];
    [self.navigationItem setHidesBackButton:NO animated:YES];

    [AlertHelper showAlertWithMessage:@"上传头像失败" withAutoDismiss:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ChangeNameViewController class]]) {
        [segue.destinationViewController setNameString:_currentUser.userName];
    }
}


@end
