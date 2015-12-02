//
//  Record.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/25/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "Record.h"

static NSString *kDefaultString = @"--";

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

- (NSString *)bookName {
    return [self isStringEmpty:_bookName] ? kDefaultString : _bookName;
}

- (NSString *)borrowerName {
    return [self isStringEmpty:_borrowerName] ? kDefaultString : _borrowerName;
}

- (NSString *)lenderName {
    return [self isStringEmpty:_lenderName] ? kDefaultString : _lenderName;
}

- (NSString *)applicationTime {
    return [self isStringEmpty:_applicationTime] ? kDefaultString : [_applicationTime substringToIndex:10];
}

- (NSString *)borrowTime {
    return [self isStringEmpty:_borrowTime] ? kDefaultString : [_borrowTime substringToIndex:10];
}

- (NSString *)returnTime {
    return [self isStringEmpty:_returnTime] ? kDefaultString : [_returnTime substringToIndex:10];
}

- (BOOL)isStringEmpty:(NSString *)string {
    return [string isEqual:[NSNull null]] || [string length] == 0;
}

@end
