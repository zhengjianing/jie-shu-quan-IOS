//
//  ChangeNameViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-22.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "ServerHeaders.h"
#import "ASIFormDataRequest.h"
#import "AlertHelper.h"
#import "CustomActivityIndicator.h"

@interface ChangeNameViewController ()
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [UserManager currentUser];
    [self.view addSubview:self.activityIndicator];
    _nameTextField.text = _nameString;
}

- (void)disableCancelButton
{
    [_cancelButton setEnabled:NO];
}

- (void)enableCancelButton
{
    [_cancelButton setEnabled:YES];
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
}

- (IBAction)saveInput:(id)sender {
    [self disableCancelButton];

    [_activityIndicator startAnimating];

    [self changeCurrentUserName];
}

- (IBAction)cancelInput:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)changeCurrentUserName
{
    [self startUploadingUserName];
}

- (void)startUploadingUserName
{
    NSURL *changeUserNameURL = [NSURL URLWithString:[kChangeUserNameURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:changeUserNameURL];
    [request addPostValue:_currentUser.userId forKey:@"user_id"];
    [request addPostValue:_currentUser.accessToken forKey:@"access_token"];
    [request addPostValue:_nameTextField.text forKey:@"user_name"];
    
    [request buildPostBody];
    [request setTimeOutSeconds:5];

    [request setDidReceiveDataSelector:@selector(requestDidReceiveData:)];
    [request setDidFailSelector:@selector(requestDidFail:)];

    [request setDelegate:self];
    [request startSynchronous];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestDidReceiveData:(ASIFormDataRequest *)request
{
    [_activityIndicator stopAnimating];

    if ([request responseStatusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"修改用户名失败" withAutoDismiss:YES target:self];
        [self enableCancelButton];
        return;
    }
    
    [self enableCancelButton];
    //    [self performSelector:@selector(enableCancelButton) withObject:nil afterDelay:1];

    [AlertHelper showNoneButtonAlertWithMessage:@"修改用户名成功" autoDismissIn:1 target:self];

    // save change to UserStore
    //惊讶地发现，原来写的saveUserToCoreData方法居然可以兼容仅修改名字！！！哈哈
    _currentUser.userName = _nameTextField.text;
    [[UserStore sharedStore] saveUserToCoreData:_currentUser];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    [_activityIndicator stopAnimating];
    [self enableCancelButton];
    [AlertHelper showAlertWithMessage:@"用户名修改失败" withAutoDismiss:YES target:self];
}


@end
