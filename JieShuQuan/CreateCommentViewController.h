//
//  CreateCommentViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/25/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;
@class CustomActivityIndicator;

@interface CreateCommentViewController : UIViewController

@property (strong, nonatomic) Book *book;
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@end
