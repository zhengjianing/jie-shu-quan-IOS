//
//  BookCommentTableViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreLoginView.h"
@class Book;
@class CustomActivityIndicator;

@interface BookCommentTableViewController : UITableViewController <PreLoginDelegate>

@property (weak, nonatomic) IBOutlet UIView *bookDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (strong, nonatomic) Book *book;

@property (strong, nonatomic) NSMutableArray *CommentCellObject;
@property (strong, nonatomic) UILabel *messageLabel;

@end
