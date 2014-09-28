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

// singleton
+ (CustomAlert *)sharedAlert
{
    static CustomAlert *sharedAlert = nil;
    if (!sharedAlert) {
        sharedAlert = [[super allocWithZone:nil] init];
    }
    return sharedAlert;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedAlert];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setFrame:CGRectMake(40, 300, 240, 30)];
//        self.layer.cornerRadius = 5.0;
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
        
        self.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:fontSize];
        self.hidden = YES;
    }
    return self;
}

- (void)showAlertWithMessage:(NSString *)message
{
    self.hidden = NO;
    [self setAlertWithText:message];
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2.0];
}

#pragma mark - private methods

- (void)setAlertWithText:(NSString*)text {
    self.text = text;
    self.numberOfLines = 0;
    self.textAlignment = UITextAlignmentCenter;
    
    CGSize constrainedSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGSize commentTextSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize+LINESPACE/2] constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, constrainedSize.width, commentTextSize.height);
}

- (void)dismissAlert
{
    self.hidden = YES;
}

@end
