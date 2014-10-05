//
//  TabBarItemHelper.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 10/5/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FAKIonIcons.h>

@interface TabBarItemHelper : NSObject

+ (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title icon:(FAKIonIcons *)icon;
@end
