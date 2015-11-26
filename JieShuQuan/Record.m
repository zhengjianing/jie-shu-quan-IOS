//
//  Record.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/25/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "Record.h"

@implementation Record

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self && dic) {
        self.bookId = dic[@"book_id"];
        self.bookName = dic[@"book_name"];
        self.bookImageURL = dic[@"book_image_url"];
        self.borrowerId = dic[@"borrower_id"];
        self.borrowerName = dic[@"borrower_name"];
        self.lenderId = dic[@"lender_id"];
        self.lenderName = dic[@"lender_name"];
        self.bookStatus = dic[@"status"];
        self.applicationTime = dic[@"application_time"];
        self.borrowTime = dic[@"borrow_time"];
        self.returnTime = dic[@"return_time"];
    }
   
    return self;
};

@end
