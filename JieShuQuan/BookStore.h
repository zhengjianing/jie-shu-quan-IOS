//
//  BookStore.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface BookStore : NSObject

+ (NSArray *)fetchBooksFromStore;

@end
