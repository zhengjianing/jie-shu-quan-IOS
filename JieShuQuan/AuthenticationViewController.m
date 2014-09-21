//
//  AuthenticationDelegate.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-10.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "BookStore.h"
#import "UserStore.h"
#import "DataConverter.h"
#import "User.h"
#import "UserManager.h"
#import "AlertHelper.h"
#import "FriendStore.h"

@implementation AuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    [self.view addSubview:_activityIndicator];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"验证失败" withAutoDismiss:YES target:self];
    }
    [self.activityIndicator stopAnimating];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        // when login/Register succeeded, send notice to MyBooksViewController to fetch books from server
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [AlertHelper showAlertWithMessage:@"网络请求失败...\n请检查您的网络连接" withAutoDismiss:YES target:self];
}

@end
