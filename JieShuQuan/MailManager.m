//
//  MailManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/19/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MailManager.h"
#import <MessageUI/MessageUI.h>
#import "UserManager.h"
#import "User.h"

static const NSString *kBorrowBookSubject = @"借书圈借书需求";
static const NSString *kBorrowBookBody = @"你好，%@\n\n能否将《%@》借给我？谢谢\n\n%@";

@implementation MailManager

+ (void)displayComposerSheetToName:(NSString *)toName toEmailAddress:(NSString *)toEmailAddress forBook:(NSString *)bookName delegate:(id)delegate
{
    NSString *fromName = [[UserManager currentUser] userName];

    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    NSString *body = [NSString stringWithFormat:(NSString *)kBorrowBookBody, toName, bookName, fromName];
    mailViewController.mailComposeDelegate = delegate;
    [mailViewController setSubject:(NSString *)kBorrowBookSubject];
    [mailViewController setToRecipients:@[toEmailAddress]];
    [mailViewController setMessageBody:body isHTML:NO];
    
    [delegate presentViewController:mailViewController animated:YES completion:nil];
}

+ (void)launchMailToName:(NSString *)toName toEmailAddress:(NSString *)toEmailAddress forBook:(NSString *)bookName
{
    NSString *fromName = [[UserManager currentUser] userName];
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=%@", toEmailAddress, (NSString *)kBorrowBookSubject];
    NSString *body = [NSString stringWithFormat:(NSString *)kBorrowBookBody, toName, bookName, fromName];
    NSString *emailContent = [NSString stringWithFormat:@"%@%@", recipients, body];
    emailContent = [emailContent stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:emailContent]];
}

@end
