//
//  CustomAlert.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlert : UIWindow

- (void)showAlertWithMessage:(NSString *)message;

+ (CustomAlert *)sharedAlert;

@end
