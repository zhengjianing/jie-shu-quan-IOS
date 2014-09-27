//
//  FriendsHasBookTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreLoginView.h"
#import <MessageUI/MessageUI.h>

@class Book;
@class CustomActivityIndicator;

@interface FriendsHasBookTableViewController : UITableViewController <PreLoginDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)changeSegmentControl:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bookDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)borrowFromFriend:(id)sender;
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@property (strong, nonatomic) Book *book;

@property (strong, nonatomic) NSMutableArray *friendsCellObject;
@property (strong, nonatomic) NSMutableArray *allFriendsCellObject;
@property (strong, nonatomic) NSMutableArray *localFriendsCellObject;

@property (strong, nonatomic) UILabel *messageLabel;

@end
