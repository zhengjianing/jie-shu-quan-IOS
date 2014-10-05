//
//  TabBarItemHelper.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 10/5/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "TabBarItemHelper.h"

@implementation TabBarItemHelper

+ (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title icon:(FAKIonIcons *)icon
{
    UIImage *image = [icon imageWithSize:CGSizeMake(20, 20)];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    return tabBarItem;
}

@end
