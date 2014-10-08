//
//  PublicAccountTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-10-8.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "PublicAccountTableViewController.h"

@implementation PublicAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微信公众账号";
    UIImage *qrCodeImage = [UIImage imageNamed:@"qrcode_for_gh_9435ba066d3c_430.jpg"];
    [_QRCodeImageView setImage:qrCodeImage];
}

@end
