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
    
    if (_searchedBook) {
        [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_searchedBook.imageHref]];
        _nameLabel.text = _searchedBook.name;
        _authorsLabel.text = [_searchedBook authorsString];
        _publisherLabel.text = _searchedBook.publisher;
        _publishDateLabel.text = _searchedBook.publishDate;
        _priceLabel.text = _searchedBook.price;
        _discriptionLabel.text = _searchedBook.description;
        _authorInfoLabel.text = _searchedBook.authorInfo;
    } else {
        [_bookImageView sd_setImageWithURL:[NSURL URLWithString:[_storedBook valueForKey:@"imageHref"]]];
        _nameLabel.text = [_storedBook valueForKey:@"name"];
        _authorsLabel.text = [[_storedBook valueForKey:@"authors"] componentsJoinedByString:@", "];
        _publisherLabel.text = [_storedBook valueForKey:@"publisher"];
        _publishDateLabel.text = [_storedBook valueForKey:@"publishDate"];
        _priceLabel.text = [_storedBook valueForKey:@"price"];
        _discriptionLabel.text = [_storedBook valueForKey:@"bookDescription"];
        _authorInfoLabel.text = [_storedBook valueForKey:@"authorInfo"];
    }
}

- (IBAction)addBook:(id)sender {
    if (!_searchedBook || [[BookStore sharedStore] storeHasBook:_searchedBook]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Book Already Exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    } else {
        [[BookStore sharedStore] addBookToStore:_searchedBook];
    }
}

@end
