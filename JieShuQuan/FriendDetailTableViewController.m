//
//  FriendDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendDetailTableViewController.h"
#import "FriendBookTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Friend.h"
#import "Book.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "User.h"
#import "AlertHelper.h"
#import "DataConverter.h"

@interface FriendDetailTableViewController ()

@end

@implementation FriendDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureFriendInfoView];
    
    _books = [[NSMutableArray alloc] init];
    
    [self loadBooksForFriend];
    [self.tableView reloadData];
}

- (void)configureFriendInfoView
{
    _friendNameLabel.text = _friend.friendName;
    _friendBookCountLabel.text = _friend.bookCount;
    _friendEmailLabel.text = _friend.friendEmail;
}

- (void)loadBooksForFriend
{
    [self fetchBooksForFriendFromServer];
}

#pragma mark - fetch books for friend from server

- (void)fetchBooksForFriendFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:_friend.friendId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_books removeAllObjects];
            
            NSArray *booksArray = [responseObject valueForKey:@"books"];
            for (id bookItem in booksArray) {
                Book *book = [DataConverter bookFromServerBookObject:bookItem];
                [_books addObject:book];
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendBookIdentifier" forIndexPath:indexPath];
    
    Book *book = [_books objectAtIndex:indexPath.row];
    
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    cell.bookNameLabel.text = book.name;
    cell.authorsLabel.text = book.authors;
    cell.availabilityLabel.text = (book.availability == NO) ? @"暂时不可借" : @"可借";
    
    return cell;
}

@end
