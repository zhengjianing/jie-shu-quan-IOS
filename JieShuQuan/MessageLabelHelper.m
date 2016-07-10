//
//  ViewHelper.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/19/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MessageLabelHelper.h"
#import "ViewFrameHelper.h"
@implementation MessageLabelHelper

+ (UILabel *)createMessageLabelWithMessage:(NSString *)message
{
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150,Screen_Width - 50*2, 200.0)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont fontWithName:@"Arial" size:15.0f];
    return messageLabel;
}

@end
