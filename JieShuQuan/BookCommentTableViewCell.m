//
//  BookCommentTableViewCell.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookCommentTableViewCell.h"

@implementation BookCommentTableViewCell

static const int kMarginLeftRight = 20;
static const int kMarginTopBottom = 10;
static const int kSubTitleHeight = 13;
static const int kUsernameWidth = 210;
static const int kDateWidth = 90;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *commentFont = [UIFont systemFontOfSize:13];
        UIColor *commentColor = [UIColor darkGrayColor];
        
        UIFont *subTitleFont = [UIFont systemFontOfSize:11];
        UIColor *subTitleColor = [UIColor brownColor];

        _bookCommentLabel = [[UILabel alloc] init];
        _bookCommentLabel.font = commentFont;
        _bookCommentLabel.textColor = commentColor;
        [self.contentView addSubview:_bookCommentLabel];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = subTitleFont;
        _userNameLabel.textColor = subTitleColor;
        [self.contentView addSubview:_userNameLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = subTitleFont;
        _dateLabel.textColor = subTitleColor;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void)setCommentLabelWithText:(NSString*)text {
    self.bookCommentLabel.text = text;
    self.bookCommentLabel.numberOfLines = 0;
    
    CGSize constrainedSize = CGSizeMake(self.contentView.frame.size.width - 2*kMarginLeftRight, MAXFLOAT);
    CGSize commentTextSize = [text sizeWithFont:self.bookCommentLabel.font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.bookCommentLabel.frame = CGRectMake(kMarginLeftRight, kMarginTopBottom, constrainedSize.width, commentTextSize.height);
}

-(void)setUserNameLabelWithText:(NSString*)username
{
    self.userNameLabel.text = username;
    self.userNameLabel.frame = CGRectMake(kMarginLeftRight, self.bookCommentLabel.frame.size.height + 2*kMarginTopBottom, kUsernameWidth, kSubTitleHeight);
}

-(void)setDateLabelWithText:(NSString *)date
{
    self.dateLabel.text = date;
    self.dateLabel.frame = CGRectMake(kUsernameWidth + kMarginLeftRight, self.bookCommentLabel.frame.size.height + 2*kMarginTopBottom, kDateWidth, kSubTitleHeight);
}

- (void)setCellFrame
{
    CGRect frame = [self frame];
    frame.size.height = self.bookCommentLabel.frame.size.height + kSubTitleHeight + 3*kMarginTopBottom;
    self.frame = frame;
}

@end
