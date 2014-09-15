//
//  FriendsTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendInfoTableViewCell.h"
#import "LoginViewController.h"
#import "ServerHeaders.h"
#import "UserManager.h"
#import "RequestBuilder.h"
#import "User.h"
#import "Friend.h"
#import "AlertHelper.h"
#import "FriendStore.h"
#import "DataConverter.h"

@interface FriendsTableViewController ()

@property (strong, nonatomic) UITableView *myFriendsTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myFriends;
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myFriendsTableView = self.tableView;
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self addRefreshControll];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserManager isLogin]) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
}

- (void)showTableView
{
    [self loadFriendsFromStore];
    self.view = _myFriendsTableView;
    [_myFriendsTableView reloadData];
}

- (void)loadFriendsFromStore
{
    _myFriends = [[[FriendStore sharedStore] storedFriends] mutableCopy];
}

#pragma mark - PreLoginView

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
}

- (void)showPreLoginView
{
    if (!_preLoginView) {
        [self initPreLoginViewWithNib];
    }
    self.view = _preLoginView;
}

- (void)initPreLoginViewWithNib
{
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginNib" owner:self options:nil];
    if ([topLevelObjs count] > 0)
    {
        _preLoginView = [topLevelObjs lastObject];
        _preLoginView.delegate = self;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendInfoIdentifier"];
    Friend *friend = [_myFriends objectAtIndex:indexPath.row];
    cell.userNameLabel.text = friend.friendName;
    cell.bookCountLabel.text = friend.bookCount;
    cell.emailLabel.text = friend.friendEmail;
    
    return cell;
}

#pragma mark - fetch friends from server

- (void)fetchFriendsFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchFriendsRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_myFriends removeAllObjects];
            [[FriendStore sharedStore] emptyFriendStoreForCurrentUser];

            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                [[FriendStore sharedStore] addFriendToStore:friend];
            }

            [self loadFriendsFromStore];
            [self.tableView reloadData];
            [self updateRefreshControl];
        }
    }];
}

#pragma mark - pull to refresh

- (void)addRefreshControll
{
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refresh;
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    [self fetchFriendsFromServer];
}

- (void)updateRefreshControl
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    _refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(endRefreshing) userInfo:nil repeats:NO];
}

- (void)endRefreshing {
    [_refresh endRefreshing];
}

@end
