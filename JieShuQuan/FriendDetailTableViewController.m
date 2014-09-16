//
//  FriendDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendDetailTableViewController.h"
#import "Friend.h"

@interface FriendDetailTableViewController ()

@end

@implementation FriendDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureFriendInfoView];
}

- (void)configureFriendInfoView
{
    _friendNameLabel.text = _friend.friendName;
    _friendBookCountLabel.text = _friend.bookCount;
    _friendEmailLabel.text = _friend.friendEmail;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendBookIdentifier" forIndexPath:indexPath];
    
    
    return cell;
}

@end
