//
//  RecordsViewModel.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/25/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "RecordsViewModel.h"
#import <UIKit/UIKit.h>
#import "Record.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation RecordsViewModel

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initBookStatusDic];
    }
    
    return self;
};

- (void)initBookStatusDic
{
    self.bookStatusDic = @{@"pending":@{@"text":@"未处理",
                                        @"color":UIColorFromRGB(0xFF6666)},
                           @"approved":@{@"text":@"已同意借阅",
                                         @"color":UIColorFromRGB(0x99CC99)},
                           @"declined":@{@"text":@"已拒绝借阅",
                                         @"color":UIColorFromRGB(0xCCCCCC)},
                           @"returned":@{@"text":@"已归还",
                                         @"color":UIColorFromRGB(0x99CCCC)}};
};

- (void)fetchLenderRecordsWithUserId:(NSString *) userId success:(GetLenderRecordsSuccessBlock) success failure:(GetLenderRecordsFailureBlock) failure
{
    BorrowService *borrowService = [BorrowService new];
    
    [borrowService getLenderRecordsWithLenderId:userId success:^(NSArray *lenderRecordsArray) {
        success([RecordsViewModel convertToRecordsArrayFromArray:lenderRecordsArray]);
    } failure:^{
        failure();
    }];
}

+ (NSArray *)convertToRecordsArrayFromArray:(NSArray *) array
{
    NSMutableArray *lenderRecords = [NSMutableArray new];
    
    if (array) {
        for (NSDictionary *dic in array) {
            Record *record = [[Record alloc] initWithDic:dic];
            [lenderRecords addObject:record];
        }
    }
    
    return lenderRecords;
}

@end
