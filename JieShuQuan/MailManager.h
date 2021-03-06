//
//  MailManager.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/19/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailManager : NSObject

+ (void)displayComposerSheetToName:(NSString *)toName toEmailAddress:(NSString *)emailAddress forBook:(NSString *)book delegate:(id)delegate;
+ (void)launchMailToName:(NSString *)toName toEmailAddress:(NSString *)emailAddress forBook:(NSString *)bookName;

+ (void)displayComposerSheetToEmailAddress:(NSString *)emailAddress delegate:(id)delegate;
+ (void)launchMailToEmailAddress:(NSString *)emailAddress;

@end
