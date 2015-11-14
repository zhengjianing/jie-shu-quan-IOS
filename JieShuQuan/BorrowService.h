//
//  BorrowService.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 11/14/15.
//  Copyright (c) 2015 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowService : NSObject

typedef void(^CreateBorrowRecordSuccessBlock)();
typedef void(^CreateBorrowRecordFailureBlock)();

- (void)createBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(CreateBorrowRecordSuccessBlock)successBlock failure:(CreateBorrowRecordFailureBlock)failureBlock;

@end