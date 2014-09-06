//
//  BookStore.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookStore.h"

@interface BookStore ()
{
    NSArray *storedBooks;
}
- (NSArray *)fetchBooksFromStore;

@end

@implementation BookStore

+ (BookStore *)sharedStore
{
    static BookStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        storedBooks = [self fetchBooksFromStore];
    }
    return self;
}

- (NSArray *)storedBooks
{
    return storedBooks;
}

- (void)refreshStore
{
    storedBooks = [self fetchBooksFromStore];
}

- (NSArray *)fetchBooksFromStore
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSArray *booksArray = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    [request setPredicate:predicate];
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
