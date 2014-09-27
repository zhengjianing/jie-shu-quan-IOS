//
//  CustomAlert.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomAlert.h"

static const float fontSize = 12;
static const float LINESPACE = 5;

@implementation CustomAlert

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(40, 300, 240, 30)];
        self.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
//        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.hidden = YES;
    }
    return self;
}

- (void)showAlertWithMessage:(NSString *)message
{
    [self setAlertWithText:message];
    self.hidden = NO;
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2.0];
}

#pragma mark - private methods

- (void)setAlertWithText:(NSString*)text {
    self.text = text;
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:fontSize];
    self.numberOfLines = 0;
    self.textAlignment = UITextAlignmentCenter;
    
    CGSize constrainedSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGSize commentTextSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize+LINESPACE/2] constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, constrainedSize.width, commentTextSize.height);
}

- (void)dismissAlert
{
//    self.hidden = YES;
}

@end
