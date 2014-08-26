//
//  LoginViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "LoginViewController.h"
#import "DoubanHeaders.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLoginViewController) name:@"popLoginViewController" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _auth = [[DoubanAuthorize alloc] init];
    [self logIn];
}

- (void)logIn
{
    NSMutableURLRequest *request = [_auth startAuthorize];
    [_webView loadRequest:request];
}

- (void)sendTokenRequestWithCode:(NSString *)code
{
    NSLog(@"code:\n%@", code);
    [_auth requestAccessTokenWithAuthorizeCode:code];
}

- (void)popLoginViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate medthods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *urlString = url.absoluteString;
    
    if ([urlString hasPrefix:kRedirect_URL])
    {
        NSString *codePart = url.query;
        NSRange range = [codePart rangeOfString:@"code="];
        if (range.location != NSNotFound)
        {
            NSString *code = [codePart substringFromIndex:range.location+range.length];
            [self sendTokenRequestWithCode:code];
        }
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Load Failed with error: %@, error userInfo: %@", error, [error userInfo]);
    NSLog(@"Localized description: %@", error.localizedDescription);
    if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Network connection is broken..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

@end
