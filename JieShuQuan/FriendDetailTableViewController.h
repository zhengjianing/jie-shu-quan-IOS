//
//  FriendDetailTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class Friend;

@interface FriendDetailTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *friendInfoView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendBookCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendEmailLabel;

- (IBAction)borrowFromFriend:(id)sender;

@property (strong, nonatomic) Friend *friend;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) UILabel *messageLable;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
