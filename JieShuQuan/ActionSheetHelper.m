//
//  ActionSheetHelper.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-14.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ActionSheetHelper.h"

@implementation ActionSheetHelper

+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title delegate:(id)object
{
    return [[UIActionSheet alloc] initWithTitle:title delegate:object cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
}

@end
