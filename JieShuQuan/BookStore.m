//
//  BookStore.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-2.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "BookStore.h"
#import "Book.h"
#import "UserStore.h"

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[UserStore sharedStore] currentUserId]];
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

- (void)addBookToStore:(Book *)book
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
    
    [newBook setValue:book.name forKey:@"name"];
    [newBook setValue:book.authors forKey:@"authors"];
//    [newBook setValue:UIImageJPEGRepresentation(_bookImageView.image, 1.0)  forKey:@"imageData"];
    [newBook setValue:book.description forKey:@"bookDescription"];
    [newBook setValue:book.authorInfo forKey:@"authorInfo"];
    [newBook setValue:book.price forKey:@"price"];
    [newBook setValue:book.publisher forKey:@"publisher"];
    [newBook setValue:book.bookId forKey:@"bookId"];
    [newBook setValue:book.publishDate forKey:@"publishDate"];
    
    NSArray *usersArray = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", [[UserStore sharedStore] currentUserId]];
    [request setPredicate:predicate];
    NSError *error = nil;
    usersArray = [context executeFetchRequest:request error:&error];
    if (![usersArray count]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    NSManagedObject *currentUser = usersArray[0];
    NSMutableSet *set = [currentUser mutableSetValueForKey:@"books"];
    [set addObject:newBook];
    
    [delegate saveContext];
    [[BookStore sharedStore] refreshStore];
}

@end
