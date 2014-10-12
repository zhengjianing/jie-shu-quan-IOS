//
//  AboutTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/27/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "AboutTableViewController.h"
#import "MobClick.h"

@interface AboutTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;

@end

@implementation AboutTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self setTableFooterView];
    _appIconImageView.layer.masksToBounds = YES;
    _appIconImageView.layer.cornerRadius = 5.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"aboutPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"aboutPage"];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

@end
