//
//  FriendHasBookTableViewCell.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/16/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendHasBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *friendAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendBookAvailibilityLabel;
@property (weak, nonatomic) IBOutlet UIButton *borrowButton;

@end
