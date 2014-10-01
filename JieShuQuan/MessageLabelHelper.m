//
//  ViewHelper.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/19/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MessageLabelHelper.h"

@implementation MessageLabelHelper

+ (UILabel *)createMessageLabelWithMessage:(NSString *)message
{
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 220, 200.0)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont fontWithName:@"Arial" size:13.0f];
    return messageLabel;
}

@end
