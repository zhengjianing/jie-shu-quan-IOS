//
//  FriendsHasBookTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendsHasBookTableViewController.h"
#import "Book.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsHasBookTableViewController ()

@end

@implementation FriendsHasBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBookInfoView];
}

- (void)configureBookInfoView
{
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = _book.authors;
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookDetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"friend";
    
    return cell;
}

@end
