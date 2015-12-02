//
//  NotificationPushManager.h
//  JieShuQuan
//
//  Created by Yanzi Li on 12/2/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationPushManager : NSObject

+ (void)pushNotificationForBorrowingBook:(NSString *)bookName toFriend:(Friend *)friend;
@end
