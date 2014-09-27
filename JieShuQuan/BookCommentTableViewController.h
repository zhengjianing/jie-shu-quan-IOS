//
//  BookCommentTableViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActivityIndicator.h"

@class Book;

@interface BookCommentTableViewController : UITableViewController

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (strong, nonatomic) Book *book;

@property (strong, nonatomic) NSMutableArray *CommentCellObject;
@property (strong, nonatomic) UILabel *messageLabel;

@end
