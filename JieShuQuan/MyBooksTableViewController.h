//
//  MyBooksTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreLoginView.h"
#import "BookStore.h"
#import "Book.h"

@interface MyBooksTableViewController : UITableViewController <PreLoginDelegate>

@property (strong, nonatomic) UITableView *myBooksTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;

@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) BookStore *sharedBookStore;

- (void)showTableView;

@end
