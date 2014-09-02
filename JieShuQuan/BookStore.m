//
//  BookStore.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookStore.h"

@implementation BookStore

+ (NSArray *)fetchBooksFromStore
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSArray *booksArray = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    booksArray = [context executeFetchRequest:request error:&error];
    if (!booksArray) {
        NSLog(@"Fetch Cache Failed: %@, %@", error, [error userInfo]);
    }
    return booksArray;
}

@end
