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
@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //不是不用activityIndicator，而是它太快了，等activityIndicator刚显示出来就瞬间没了！！！
//    [self.view addSubview:self.activityIndicator];
}

//- (CustomActivityIndicator *)activityIndicator
//{
//    if (_activityIndicator != nil) {
//        return _activityIndicator;
//    }
//    
//    _activityIndicator = [[CustomActivityIndicator alloc] init];
//    return _activityIndicator;
//}

- (IBAction)saveInput:(id)sender {
//    [_activityIndicator startAnimating];

    [self changeCurrentUserNameTo:_nameTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelInput:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private method

- (void)changeCurrentUserNameTo:(NSString *)newName
{
    // Just for temporary user, delete later
    User *user = [UserManager currentUser];
    user.userName = newName;
    //惊讶地发现，原来写的saveUserToCoreData方法居然可以兼容仅修改名字！！！哈哈
    [[UserStore sharedStore] saveUserToCoreData:user];
    
    [self startUploadingUserName];
}

- (void)startUploadingUserName
{
    NSURL *changeUserNameURL = [NSURL URLWithString:kChangeBookStatusURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:changeUserNameURL];
    
    [request setDelegate:self];
    //若用async，则会crash，原因可能是请求尚未完成，此viewcontroller已经将自己dismissViewControllerAnimated，故request.delegate突然变成nil了。
    //另外就是QQ里说的，要不就不管网络是否连接，先在本地改成功，然后抽空去给服务器发数据？？
//    [request startAsynchronous];
    [request startSynchronous];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestDidReceiveData:(ASIFormDataRequest *)request
{
//    [_activityIndicator stopAnimating];
    if ([request responseStatusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"用户名修改失败" withAutoDismiss:YES target:self];
        return;
    }
    
    // change UserStore and UserManager
    // TBD...
    
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
//    [_activityIndicator stopAnimating];
    [AlertHelper showAlertWithMessage:@"用户名修改失败" withAutoDismiss:YES target:self];
}


@end
