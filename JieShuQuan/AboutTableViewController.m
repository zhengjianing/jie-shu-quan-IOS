//
//  AboutTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/27/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTableFooterView];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

@end
