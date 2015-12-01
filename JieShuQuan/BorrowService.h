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
typedef void(^CreateBorrowRecordFailureBlock)(NSString *errorMessage);

typedef void(^ApproveBorrowRecordSuccessBlock)();
typedef void(^ApproveBorrowRecordFailureBlock)(NSString *errorMessage);

typedef void(^DeclineBorrowRecordSuccessBlock)();
typedef void(^DeclineBorrowRecordFailureBlock)(NSString *errorMessage);

typedef void(^ReturnBorrowRecordSuccessBlock)();
typedef void(^ReturnBorrowRecordFailureBlock)(NSString *errorMessage);

typedef void(^GetBorrowerRecordsSuccessBlock)(NSArray *borrowingRecordsArray);
typedef void(^GetBorrowerRecordsFailureBlock)(NSString *errorMessage);

typedef void(^GetLenderRecordsSuccessBlock)(NSArray *lendingRecordsArray);
typedef void(^GetLenderRecordsFailureBlock)(NSString *errorMessage);

- (void)createBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(CreateBorrowRecordSuccessBlock)successBlock failure:(CreateBorrowRecordFailureBlock)failureBlock;

- (void)approveBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ApproveBorrowRecordSuccessBlock)successBlock failure:(ApproveBorrowRecordFailureBlock)failureBlock;

- (void)declineBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(DeclineBorrowRecordSuccessBlock)successBlock failure:(DeclineBorrowRecordFailureBlock)failureBlock;

- (void)returnBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ReturnBorrowRecordSuccessBlock)successBlock failure:(ReturnBorrowRecordFailureBlock)failureBlock;

- (void)getBorrowerRecordsWithBorrowerId:(NSString *)borrowerId success:(GetBorrowerRecordsSuccessBlock)successBlock failure:(GetBorrowerRecordsFailureBlock)failureBlock;

- (void)getLenderRecordsWithLenderId:(NSString *)lenderId success:(GetLenderRecordsSuccessBlock)successBlock failure:(GetLenderRecordsFailureBlock)failureBlock;

@end