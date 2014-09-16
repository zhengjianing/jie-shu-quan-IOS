//
//  FriendDetailTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Friend;

@interface FriendDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *friendInfoView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendBookCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendEmailLabel;

@property (strong, nonatomic) Friend *friend;
@property (strong, nonatomic) NSMutableArray *books;

@end
