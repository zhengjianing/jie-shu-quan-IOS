//
//  DataManager.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookStore : NSObject

@property (strong, nonatomic) NSMutableArray *allBooks;

+ (BookStore *)sharedStore;

- (NSMutableArray *)allBooks;
- (void)createBooks;

@end
