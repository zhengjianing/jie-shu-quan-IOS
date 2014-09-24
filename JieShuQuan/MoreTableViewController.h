//
//  MoreTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/12/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewController : UITableViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pleaseLoginLabel;

@property (weak, nonatomic) IBOutlet UILabel *bookCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;

@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;

@end
