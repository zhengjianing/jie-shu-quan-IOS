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

@implementation AuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicator];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"%d", statusCode);
    if (statusCode != 200) {
        [AlertHelper showAlertWithMessage:@"验证失败" target:self];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
    [AlertHelper showAlertWithMessage:@"网络请求失败...\n请检查您的网络连接是否正确" target:self];
}

@end
