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

@interface FriendsTableViewController ()

@property (strong, nonatomic) UITableView *myFriendsTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSArray *myFriends;
@property (strong, nonatomic) LoginViewController *loginController;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myFriendsTableView = self.tableView;
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
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
//    [self loadData];
    self.view = _myFriendsTableView;
    [_myFriendsTableView reloadData];
}

- (void)loadData
{
    _myFriends = nil;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendInfoIdentifier"];
    if (!cell) {
        cell = [[FriendInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendInfoIdentifier"];
    }
    
    return cell;
}

@end
