//
//  BookCommentTableViewCell.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookCommentTableViewCell.h"

@implementation BookCommentTableViewCell

static const int padding_l_r = 20;
static const int padding_t_b = 5;
static const int fontSize = 14;
static const int usernameHeight = 20;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bookCommentLabel = [[UILabel alloc] init];
        _bookCommentLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [self.contentView addSubview:_bookCommentLabel];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [self.contentView addSubview:_userNameLabel];
    }
    return self;
}

-(void)setCommentText:(NSString*)text {
    self.bookCommentLabel.text = text;
    self.bookCommentLabel.numberOfLines = 0;
    
    CGSize constrainedSize = CGSizeMake(self.contentView.frame.size.width-padding_l_r*2, MAXFLOAT);
    CGSize commentTextSize = [self.bookCommentLabel.text sizeWithFont:self.bookCommentLabel.font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.bookCommentLabel.frame = CGRectMake(padding_l_r, padding_t_b, commentTextSize.width, commentTextSize.height + padding_t_b*4);
}

-(void)setUserNameText:(NSString*)username
{
    //not finish
    self.userNameLabel.text = username;
    self.bookCommentLabel.frame = CGRectMake(padding_l_r, _bookCommentLabel.frame.size.height + padding_l_r, 200, usernameHeight);
}

- (void)setCellFrame
{
    CGRect frame = [self frame];
    frame.size.height = self.bookCommentLabel.frame.size.height + self.userNameLabel.frame.size.height;
    self.frame = frame;
}

@end
