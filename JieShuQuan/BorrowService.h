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

typedef void(^ApproveBorrowRecordSuccessBlock)();
typedef void(^ApproveBorrowRecordFailureBlock)();

typedef void(^DeclineBorrowRecordSuccessBlock)();
typedef void(^DeclineBorrowRecordFailureBlock)();

typedef void(^ReturnBorrowRecordSuccessBlock)();
typedef void(^ReturnBorrowRecordFailureBlock)();

typedef void(^GetBorrowerRecordsSuccessBlock)();
typedef void(^GetBorrowerRecordsFailureBlock)();

typedef void(^GetLenderRecordsSuccessBlock)(NSArray *lenderRecordsArray);
typedef void(^GetLenderRecordsFailureBlock)();

- (void)createBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(CreateBorrowRecordSuccessBlock)successBlock failure:(CreateBorrowRecordFailureBlock)failureBlock;

- (void)approveBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ApproveBorrowRecordSuccessBlock)successBlock failure:(ApproveBorrowRecordFailureBlock)failureBlock;

- (void)declineBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(DeclineBorrowRecordSuccessBlock)successBlock failure:(DeclineBorrowRecordFailureBlock)failureBlock;

- (void)returnBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ReturnBorrowRecordSuccessBlock)successBlock failure:(ReturnBorrowRecordFailureBlock)failureBlock;

- (void)getBorrowerRecordsWithBorrowerId:(NSString *)borrowerId success:(GetBorrowerRecordsSuccessBlock)successBlock failure:(GetBorrowerRecordsFailureBlock)failureBlock;

- (void)getLenderRecordsWithLenderId:(NSString *)lenderId success:(GetLenderRecordsSuccessBlock)successBlock failure:(GetLenderRecordsFailureBlock)failureBlock;

@end