//
//  DataConverter.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "DataConverter.h"
#import "Book.h"

@interface DataConverter ()
+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData;
@end

@implementation DataConverter

+ (NSMutableArray *)booksArrayFromJsonData:(NSData *)jsonData
{
    id object;
    if (jsonData) {
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (!object) {
            NSLog(@"Convertion From JsonData To FoundationObject Failed: %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else {
        NSLog(@"Invalid Data...");
        abort();
    }
    return [self booksArrayFromUnserializedBooksData:[object valueForKey:@"books"]];
}

+ (NSMutableArray *)booksArrayFromUnserializedBooksData:(NSArray *)booksData
{
    NSMutableArray *booksArray = [NSMutableArray array];
    
    for (id item in booksData) {
        Book *book = [[Book alloc] init];
        book.name = [item valueForKey:@"title"];
        book.authors = [item valueForKey:@"author"];
        book.imageHref = [item valueForKey:@"image"];
        book.description = [item valueForKey:@"summary"];
        book.authorInfo = [item valueForKey:@"author_intro"];
        book.price = [item valueForKey:@"price"];
        book.publisher = [item valueForKey:@"publisher"];
        book.publishDate = [item valueForKey:@"pubdate"];
        book.bookId = [item valueForKey:@"id"];
        
        [booksArray addObject:book];
    }
    return booksArray;
}

@end
