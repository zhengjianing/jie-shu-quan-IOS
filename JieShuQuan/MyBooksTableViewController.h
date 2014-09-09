//
//  MyBooksTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreLoginView.h"
#import "Book.h"
#import "BookTableViewCell.h"
#import "BookDetailViewController.h"
@class LoginViewController;

@interface MyBooksTableViewController : UITableViewController <PreLoginDelegate>

@property (strong, nonatomic) UITableView *myBooksTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;

@property (strong, nonatomic) NSArray *myBooks;

@property (strong, nonatomic) LoginViewController *loginController;

- (void)showTableView;

@end
