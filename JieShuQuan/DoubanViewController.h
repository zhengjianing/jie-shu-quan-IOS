//
//  DoubanViewController.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanAuthorize.h"

@interface DoubanViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) DoubanAuthorize *auth;

- (void)logIn;

@end
