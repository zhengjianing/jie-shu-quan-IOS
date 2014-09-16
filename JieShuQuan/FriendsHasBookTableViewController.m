//
//  FriendsHasBookTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendsHasBookTableViewController.h"
#import "FriendHasBookTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Book.h"
#import "User.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "AlertHelper.h"
#import "Friend.h"
#import "DataConverter.h"

@interface FriendsHasBookTableViewController ()

@end

@implementation FriendsHasBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initActivityIndicator];
    [self configureBookInfoView];
    
    _friendsCellObject = [[NSMutableArray alloc] init];
    
    [self loadFriendsWithBook];
    [self.tableView reloadData];
}

- (void)initActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
    [_activityIndicator startAnimating];

}

- (void)loadFriendsWithBook
{
    [self fetchFriendsWithBookFromServer];
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

#pragma mark - fetch friends from server

- (void)fetchFriendsWithBookFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchFriendsRequestForUserId:[[UserManager currentUser] userId] bookId:_book.bookId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_friendsCellObject removeAllObjects];
            
            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                NSDictionary *friendCellDict = @{@"friend":friend, @"availability":[item valueForKey:@"available"]};
                [_friendsCellObject addObject:friendCellDict];
            }
            
            [self.tableView reloadData];
        }
        [_activityIndicator stopAnimating];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsCellObject.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendHasBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookDetailCell" forIndexPath:indexPath];
    
    NSDictionary *friendCellObject = [_friendsCellObject objectAtIndex:indexPath.row];
    Friend *friend = friendCellObject[@"friend"];
    NSInteger availability = [friendCellObject[@"availability"] integerValue];
    
    cell.friendNameLabel.text = friend.friendName;
    cell.friendEmailLabel.text = friend.friendEmail;
    cell.friendBookAvailibilityLabel.text = (availability == 0) ? @"暂时不可借" : @"可借";

    return cell;
}

@end
