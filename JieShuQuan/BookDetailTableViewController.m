//
//  BookDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/13/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookDetailTableViewController.h"
#import "Book.h"

@interface BookDetailTableViewController ()

@end

@implementation BookDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set the view components.
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
}

@end
