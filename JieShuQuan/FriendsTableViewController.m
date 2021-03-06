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
#import "FriendStore.h"
#import "DataConverter.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"
#import "AvatarManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CacheManager.h"
#import "CustomAlert.h"
#import <UMMobClick/MobClick.h>
#import "UserStore.h"

@interface FriendsTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) NSMutableArray *allFriends;
@property (strong, nonatomic) NSMutableArray *localFriends;
@property (strong, nonatomic) NSMutableArray *myFriends;
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFriendsFromServer) name:@"RefreshData" object:nil];
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.tableView addSubview:self.messageLabel];
    [self.tableView addSubview:self.preLoginView];
    _messageLabel.hidden = YES;

    [self setTableFooterView];
    
    if ([UserManager isLogin]) {
        [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
        [self fetchFriendsFromServer];
    }
    
    _allFriends = [NSMutableArray array];
    _localFriends = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.tabBarController.tabBar.hidden = NO;
    if ([UserManager isLogin]) {
        _preLoginView.hidden = YES;
        _messageLabel.hidden = YES;
        [self addRefreshControll];
        [self loadFriendsFromStore];
        [self showTableViewWithCorrectData];
    } else {
        _preLoginView.hidden = NO;
        self.refreshControl = nil;
    }
    
    [MobClick beginLogPageView:@"friendsPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"friendsPage"];
    [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (UILabel *)messageLabel
{
    if (_messageLabel != nil) {
        return _messageLabel;
    }
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"抱歉，没有找到相关同事，请向更多的同事推荐此应用"];
    return _messageLabel;
}

- (PreLoginView *)preLoginView
{
    if (_preLoginView != nil) {
        return _preLoginView;
    }
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginView" owner:self options:nil];
    if ([topLevelObjs count] > 0)
    {
        _preLoginView = [topLevelObjs lastObject];
        _preLoginView.frame = self.tableView.frame;
        _preLoginView.delegate = self;
    }
    return _preLoginView;
}

- (void)showTableViewWithCorrectData
{
    _myFriends = [self friendsForSelectedSegmentIndex:_segmentedControll.selectedSegmentIndex];
    if (_myFriends.count > 0) {
        _messageLabel.hidden = YES;
    } else {
        _messageLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)loadFriendsFromStore
{
    [_allFriends removeAllObjects];
    [_localFriends removeAllObjects];
    
    _allFriends = [[[FriendStore sharedStore] storedFriends] mutableCopy];
    for (Friend *friend in _allFriends) {
        if (![friend.friendLocation isEqualToString:@""] && [friend.friendLocation isEqualToString:[[UserManager currentUser] location]] ) {
            [_localFriends addObject:friend];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookCount" ascending:NO comparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    [_allFriends sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [_localFriends sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSString *segTitle0 = [NSString stringWithFormat:@"所有 (%lu)", (unsigned long)_allFriends.count];
    NSString *segTitle1 = [NSString stringWithFormat:@"同城 (%lu)", (unsigned long)_localFriends.count];
    
    [self setTitle:segTitle0 forSegmentedIndex:0];
    [self setTitle:segTitle1 forSegmentedIndex:1];
}

- (void)setTitle:(NSString *)title forSegmentedIndex:(NSUInteger)index
{
    [_segmentedControll setTitle:title forSegmentAtIndex:index];
}

#pragma mark - PreLoginView

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
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
    cell.userNameLabel.text = [friend.friendName isEqualToString:@""] ? friend.friendEmail : friend.friendName;
    cell.bookCountLabel.text = friend.bookCount;
    cell.locationLabel.text = friend.friendLocation;
    
    NSURL *avatarURL = [NSURL URLWithString:friend.avatarURLString];
    [cell.iconImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    [AvatarManager setAvatarStyleForImageView:cell.iconImageView];
    
    return cell;
}

#pragma mark - fetch friends from server

- (void)fetchFriendsFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchFriendsRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_refresh endRefreshing];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            _messageLabel.hidden = NO;
            return ;
        }
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"请求失败"];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [self clearFriendsAvatarCache];
            [[FriendStore sharedStore] emptyFriendStoreForCurrentUser];

            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                [[FriendStore sharedStore] addFriendToStore:friend];
            }
            [[UserStore sharedStore] setFriendsCount:friendsArray.count forUser:[[UserManager currentUser] userId]];
            [self loadFriendsFromStore];
            [self showTableViewWithCorrectData];
        }
    }];
}

- (void)clearFriendsAvatarCache
{
    for (Friend *friend in _myFriends) {
        [CacheManager clearAvatarCacheForAvatarURL:friend.avatarURLString];
    }
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
    _messageLabel.hidden = YES;
    [self fetchFriendsFromServer];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] class] == FriendDetailTableViewController.class) {
        NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
        Friend *selectedFriend = [_myFriends objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setCurrentFriend:selectedFriend];
    }
}

- (IBAction)changeSegment:(id)sender {
    [MobClick event:@"filterFriendsSegmentControlChanged"];

    [self showTableViewWithCorrectData];
}

- (NSMutableArray *)friendsForSelectedSegmentIndex:(NSInteger)index
{
    return (index == 0) ? [_allFriends mutableCopy] : [_localFriends mutableCopy];
}
@end
