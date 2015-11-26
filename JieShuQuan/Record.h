//
//  Record.h
//  JieShuQuan
//
//  Created by Yanzi Li on 11/25/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookImageURL;
@property (nonatomic, copy) NSString *borrowerId;
@property (nonatomic, copy) NSString *borrowerName;
@property (nonatomic, copy) NSString *lenderName;
@property (nonatomic, copy) NSString *lenderId;
@property (nonatomic, copy) NSString *bookStatus;
@property (nonatomic, copy) NSString *applicationTime;
@property (nonatomic, copy) NSString *borrowTime;
@property (nonatomic, copy) NSString *returnTime;

- (instancetype) initWithDic:(NSDictionary *)dic;

@end
