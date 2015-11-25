//
//  RecordsViewModel.h
//  JieShuQuan
//
//  Created by Yanzi Li on 11/25/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "BorrowService.h"
#import <Foundation/Foundation.h>

@interface RecordsViewModel : NSObject

@property (nonatomic, strong) NSDictionary *bookStatusDic;

- (void)fetchLenderRecordsWithUserId:(NSString *) userId success:(GetLenderRecordsSuccessBlock) success failure:(GetLenderRecordsFailureBlock) failure;
+ (NSArray *)convertToRecordsArrayFromArray:(NSArray *) array;

@end
