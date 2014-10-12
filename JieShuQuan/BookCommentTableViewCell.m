//
//  BookCommentTableViewCell.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookCommentTableViewCell.h"
#import "CustomColor.h"

@implementation BookCommentTableViewCell

static const int kMarginLeftRight = 20;
static const int kMarginTopBottom = 10;
static const int kSubTitleHeight = 13;
static const int kUsernameWidth = 180;
static const int kDateWidth = 120;
static const float LINESPACE = 5;
static const float commentFontSize = 13;
static const float subTitleFontSize = 11;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor *commentColor = [UIColor darkGrayColor];
        UIColor *subTitleColor = [CustomColor mainGreenColor];

        _bookCommentLabel = [[UILabel alloc] init];
        _bookCommentLabel.font = [UIFont systemFontOfSize:commentFontSize];
        _bookCommentLabel.textColor = commentColor;
        [self.contentView addSubview:_bookCommentLabel];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:subTitleFontSize];
        _userNameLabel.textColor = subTitleColor;
        [self.contentView addSubview:_userNameLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:subTitleFontSize];
        _dateLabel.textColor = subTitleColor;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void)setCommentLabelWithText:(NSString*)text {
    self.bookCommentLabel.text = text;
    self.bookCommentLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.bookCommentLabel.attributedText = attributedString;
    
    CGSize constrainedSize = CGSizeMake(self.contentView.frame.size.width - 2*kMarginLeftRight, MAXFLOAT);
    CGSize commentTextSize = [text sizeWithFont:[UIFont systemFontOfSize:commentFontSize+LINESPACE/2.0] constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
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
