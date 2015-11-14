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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"book_id" : bookId, @"borrower_id" : borrowerId, @"lender_id" : lenderId};
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:[NSString stringWithFormat:@"%@%@", kHost, kCreateBorrowRecord]
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
