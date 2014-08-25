//
//  DoubanViewController.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "DoubanViewController.h"
#import "DoubanHeaders.h"

@implementation DoubanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _auth = [[DoubanAuthorize alloc] init];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    [self.view addSubview:_webView];
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

@end
