//
//  LoginViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanAuthorize.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) DoubanAuthorize *auth;

@end
