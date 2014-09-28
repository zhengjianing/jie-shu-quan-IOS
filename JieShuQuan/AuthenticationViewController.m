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
#import "FriendStore.h"
#import "CacheManager.h"
#import "MoreTableViewController.h"
#import "AlertHelper.h"
#import "CustomAlert.h"

@implementation AuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"验证失败"];
    }
    [self.activityIndicator stopAsynchAnimating];
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
    [self.activityIndicator stopAsynchAnimating];
    [[CustomAlert sharedAlert] showAlertWithMessage:@"网络请求失败...\n请检查您的网络连接"];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // do the following in case the rootViewController is MoreTableViewController, then setSelectedViewController won't work, cuz it is already at Index 3 !
    NSArray *viewControllers = [self.navigationController viewControllers];
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
    if ([rootViewController isKindOfClass:[MoreTableViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [rootViewController.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:3]];
}

@end
