//
//  BookDetailViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BookStore.h"
#import "Book.h"

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _addBookButton.layer.cornerRadius = 5.0;
    _borrowFromFriends.layer.cornerRadius = 5.0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
   
}

- (IBAction)addBook:(id)sender {
    if ([[BookStore sharedStore] storeHasBook:_book]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Book Already Exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    } else {
        [[BookStore sharedStore] addBookToStore:_book];
    }
}

@end
