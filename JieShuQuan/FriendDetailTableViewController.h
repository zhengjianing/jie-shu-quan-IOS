//
//  FriendDetailTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BorrowService.h"
@class Friend;

@interface FriendDetailTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *friendAvatarImageView;
@property (weak, nonatomic) IBOutlet UIView *friendInfoView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendBookCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLocationLabel;

- (IBAction)borrowFromFriend:(id)sender;

@property (strong, nonatomic) Friend *currentFriend;
@property (copy, nonatomic) NSString *selectedBookId;

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) BOOL isFromMyFriends;

@end
