//
//  FriendsTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendDetailTableViewController.h"
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
#import "ViewHelper.h"
#import "ActivityIndicatorHelper.h"

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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFriendsFromServer) name:@"RefreshData" object:nil];
    
    _myFriendsTableView = self.tableView;
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self addRefreshControll];
    [self removeUnneccessaryCells];
    
    [self.tableView addSubview:self.activityIndicator];
    if ([UserManager isLogin]) {
        [_activityIndicator startAnimating];
        [self fetchFriendsFromServer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserManager isLogin]) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
}

- (void)removeUnneccessaryCells
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [ActivityIndicatorHelper activityIndicator];
    return _activityIndicator;
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
    if (_myFriends.count > 0) {
        for (UIView *subview in self.view.subviews) {
            if (subview == _messageLable) {
                [subview removeFromSuperview];
            }
        }
    } else {
        _messageLable = [ViewHelper createMessageLableWithMessage:@"没有找到您的同事，请确保您使用企业邮箱注册，并向更多的同事推荐此应用"];
        [self.view addSubview:_messageLable];
    }
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
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginView" owner:self options:nil];
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
        [_refresh endRefreshing];
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            _messageLable = [ViewHelper createMessageLableWithMessage:@"没有找到您的同事，请确保您使用企业邮箱注册，并向更多的同事推荐此应用"];
            [self.view addSubview:_messageLable];
            return ;
        }
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" withAutoDismiss:YES target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_myFriends removeAllObjects];
            [[FriendStore sharedStore] emptyFriendStoreForCurrentUser];

            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            
            if (friendsArray.count == 0) {
                _messageLable = [ViewHelper createMessageLableWithMessage:@"暂时没帮您找到同事，确认您使用企业邮箱注册，并向您的同事们推荐此应用"];
                [self.view addSubview:_messageLable];
                return;
            }
            
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                [[FriendStore sharedStore] addFriendToStore:friend];
            }
            [self loadFriendsFromStore];
            
            for (UIView *subview in self.view.subviews) {
                if (subview == _messageLable) {
                    [subview removeFromSuperview];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - pull to refresh

- (void)addRefreshControll
{
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refresh;
}

- (void)pullToRefresh:(UIRefreshControl *)refresh
{
    [self fetchFriendsFromServer];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] class] == FriendDetailTableViewController.class) {
        NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
        Friend *selectedFriend = [_myFriends objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setFriend:selectedFriend];
    }
}

@end
