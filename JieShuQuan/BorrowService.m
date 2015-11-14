//
//  BorrowService.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 11/14/15.
//  Copyright (c) 2015 JNXZ. All rights reserved.
//

#import "BorrowService.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "NSString+Extension.h"
#import "ServerHeaders.h"

@implementation BorrowService

- (void)createBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(CreateBorrowRecordSuccessBlock)successBlock failure:(CreateBorrowRecordFailureBlock)failureBlock {
    [self sendPOSTRequestWithHost:kCreateBorrowRecord bookId:bookId borrowerId:borrowerId lenderId:lenderId success:successBlock failure:failureBlock];
}

- (void)approveBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ApproveBorrowRecordSuccessBlock)successBlock failure:(ApproveBorrowRecordFailureBlock)failureBlock {
    [self sendPOSTRequestWithHost:kApproveBorrowRecord bookId:bookId borrowerId:borrowerId lenderId:lenderId success:successBlock failure:failureBlock];
}

- (void)declineBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(DeclineBorrowRecordSuccessBlock)successBlock failure:(DeclineBorrowRecordFailureBlock)failureBlock {
    [self sendPOSTRequestWithHost:kDeclineBorrowRecord bookId:bookId borrowerId:borrowerId lenderId:lenderId success:successBlock failure:failureBlock];
}

- (void)returnBorrowRecordWithBookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ReturnBorrowRecordSuccessBlock)successBlock failure:(ReturnBorrowRecordFailureBlock)failureBlock {
    [self sendPOSTRequestWithHost:kReturnBorrowRecord bookId:bookId borrowerId:borrowerId lenderId:lenderId success:successBlock failure:failureBlock];
}

- (void)getBorrowerRecordsWithBorrowerId:(NSString *)borrowerId success:(GetBorrowerRecordsSuccessBlock)successBlock failure:(GetBorrowerRecordsFailureBlock)failureBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"borrower_id" : borrowerId};
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:[NSString stringWithFormat:@"%@%@", kHost, kBorrowerRecords]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              successBlock();
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failureBlock();
          }
     ];
}

- (void)getLenderRecordsWithLenderId:(NSString *)lenderId success:(GetLenderRecordsSuccessBlock)successBlock failure:(GetLenderRecordsFailureBlock)failureBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"lender_id" : lenderId};
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:[NSString stringWithFormat:@"%@%@", kHost, kLenderRecords]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             successBlock();
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failureBlock();
         }
     ];
}


// private

- (void)sendPOSTRequestWithHost:(NSString *)host bookId:(NSString *)bookId borrowerId:(NSString *)borrowerId lenderId:(NSString *)lenderId success:(ReturnBorrowRecordSuccessBlock)successBlock failure:(ReturnBorrowRecordFailureBlock)failureBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"book_id" : bookId, @"borrower_id" : borrowerId, @"lender_id" : lenderId};
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:[NSString stringWithFormat:@"%@%@", kHost, host]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              successBlock();
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failureBlock();
          }
     ];
}

@end
