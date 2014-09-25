//
//  BookCommentTableViewCell.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *bookCommentLabel;
@property (strong, nonatomic) UILabel *userNameLabel;

-(void)setCommentText:(NSString*)comment;
-(void)setUserNameText:(NSString*)username;
- (void)setCellFrame;

@end
