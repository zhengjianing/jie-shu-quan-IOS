//
//  DataManager.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookStore.h"

@implementation BookStore

+ (BookStore *)sharedStore
{
    static BookStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (void)createBooks {
    _allBooks = [[NSMutableArray alloc] init];
    
    NSArray *authors = [[NSArray alloc] initWithObjects:@"author-1", @"author-2", nil];
//    Book *book = [[Book alloc] initWithName:@"IOS编程" authors:authors imageHref:@"http://img5.douban.com/mpic/s9042517.jpg" description:@"book discription" authorInfo:@"author info" price:@"29.0" publisher:@"publisher" publishDate:@"2013-03-02"];
//    [_allBooks addObject:book];
//    
//    book = [[Book alloc] initWithName:@"一个陌生女子的来信" authors:authors imageHref:@"http://img3.douban.com/mpic/s1119643.jpg" discription:@"book discription" authorInfo:@"author info" price:@"29.0" publisher:@"publisher" publishDate:@"2013-03-02"];
//    [_allBooks addObject:book];
    
}

- (NSMutableArray *)allBooks {
    return _allBooks;
}

@end
