//
//  NotificationPushManager.m
//  JieShuQuan
//
//  Created by Yanzi Li on 12/2/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "User.h"
#import "UserManager.h"
#import "Friend.h"
#import "NotificationPushManager.h"

@implementation NotificationPushManager

+ (void)pushNotificationForBorrowingBook:(NSString *)bookName toFriend:(Friend *)friend {
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:@"owner" equalTo:friend.friendId];

    NSString *loginUserName = [[UserManager currentUser].userName length] == 0 ? @"有人" : [UserManager currentUser].userName;

    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];

    NSDictionary *data = @{@"alert" : [NSString stringWithFormat:@"%@想借你的%@书，快点击查看吧", loginUserName, bookName],
                           @"badge" : @"Increment",
                           @"sound" : @"cheering.caf"};
    [push setData:data];
    [push sendPushInBackground];
}
@end
