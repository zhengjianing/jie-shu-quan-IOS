//
//  CustomAlert.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomAlert.h"

static const float fontSize = 14;
//static const float maxLabelWidth = 300;
static const float fixedLabelHeight = 45;
static const float yOrigin = 420;
static const float horizontalMargin = 20;

#define LabelBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define LabelTextColor [UIColor whiteColor]
#define LabelFont [UIFont boldSystemFontOfSize:fontSize]

@interface CustomAlert ()

@property (nonatomic, strong) UILabel *textLabel;

@end

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
        self.windowLevel = UIWindowLevelAlert;
        [self addSubview:self.textLabel];
        self.hidden = YES;
    }
    return self;
}

- (UILabel *)textLabel
{
    if (_textLabel != nil) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.layer.backgroundColor = LabelBackgroundColor.CGColor;
    _textLabel.layer.cornerRadius = 5.0;
    _textLabel.textColor = LabelTextColor;
    _textLabel.font = LabelFont;
    return _textLabel;
}

- (void)showAlertWithMessage:(NSString *)message
{
    self.hidden = NO;
    [self setAlertWithText:message];
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2.0];
}

#pragma mark - private methods

- (void)setAlertWithText:(NSString*)text {
    _textLabel.text = text;
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = UITextAlignmentCenter;
    
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, fixedLabelHeight);
    
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constrainedSize];
    
    self.frame = CGRectMake((320-textSize.width-2*horizontalMargin)/2, yOrigin, textSize.width+2*horizontalMargin, fixedLabelHeight);
    NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSLog(@"_textLabel.frame: %@", NSStringFromCGRect(_textLabel.frame));

}

- (void)dismissAlert
{
    self.hidden = YES;
}

@end
