//
//  IconHelper.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-10-11.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "IconHelper.h"
#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FAKIonIcons.h>
#import "CustomColor.h"

@implementation IconHelper

+ (UIImage *)emailIcon
{
    FAKIonIcons *icon = [FAKIonIcons iosEmailOutlineIconWithSize:20];
    [icon addAttribute:NSForegroundColorAttributeName value:[CustomColor mainRedColor]];
    return [icon imageWithSize:CGSizeMake(20, 20)];
}

+ (UIImage *)arrowIcon
{
    FAKIcon *icon = [FAKIonIcons chevronRightIconWithSize:10];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    return [icon imageWithSize:CGSizeMake(15, 15)];
}

+ (UIImage *)shareIcon
{
    FAKIonIcons *shareIcon = [FAKIonIcons shareIconWithSize:30];
    return [shareIcon imageWithSize:CGSizeMake(30, 30)];
}

@end
