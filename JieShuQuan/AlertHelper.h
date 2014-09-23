//
//  AlertHelper.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertHelper : NSObject

+ (void)showAlertWithMessage:(NSString *)message withAutoDismiss:(BOOL)autoDismiss target:(id)target;
+ (void)showNoneButtonAlertWithMessage:(NSString *)message autoDismissIn:(NSTimeInterval)time target:(id)target;

@end