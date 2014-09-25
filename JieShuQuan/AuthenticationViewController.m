//
//  AuthenticationDelegate.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-10.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "BookStore.h"
#import "UserStore.h"
#import "DataConverter.h"
#import "User.h"
#import "UserManager.h"
#import "AlertHelper.h"
#import "FriendStore.h"
#import "CacheManager.h"

@implementation AuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    [self.view addSubview:_activityIndicator];
    [self.view addSubview:self.freezeLayer];
    _freezeLayer.hidden = YES;
}

- (UIView *)freezeLayer
{
    if (_freezeLayer != nil) {
        return _freezeLayer;
    }
    
    _freezeLayer = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.x, self.view.frame.size.width, self.view.frame.size.height)];
    _freezeLayer.backgroundColor = [UIColor darkGrayColor];
    _freezeLayer.alpha = 0.3;
    return _freezeLayer;
}


#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"验证失败" withAutoDismiss:YES];
    }
    [self.activityIndicator stopAnimating];
    _freezeLayer.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (userObject) {
        User *user = [DataConverter userFromHTTPResponse:userObject];
        [[UserStore sharedStore] saveUserToCoreData:user];
        [UserManager saveUserToUserDefaults:user];
        [[BookStore sharedStore] refreshStoredBooks];
        [[FriendStore sharedStore] refreshStoredFriends];
        [CacheManager clearAvatarCacheForUserId:user.userId];
        
        if ([self isKindOfClass:[RegisterViewController class]]) {
            [AlertHelper showAlertWithMessage:@"注册成功，\n请前往“更多”页面完善个人资料" withAutoDismiss:NO delegate:self];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        // when login/Register succeeded, send notice to MyBooksViewController to fetch books from server
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    [AlertHelper showAlertWithMessage:@"网络请求失败...\n请检查您的网络连接" withAutoDismiss:YES];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
