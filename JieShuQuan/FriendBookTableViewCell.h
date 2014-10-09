//
//  FriendBookTableViewCell.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendBookTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (strong, nonatomic) IBOutlet UIButton *borrowButton;
@property (strong, nonatomic) IBOutlet UIImageView *mailImageView;

@property (copy, nonatomic) NSString *bookId;

@end
