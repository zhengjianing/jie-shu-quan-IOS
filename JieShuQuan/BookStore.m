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
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface BookStore ()
{
    NSArray *storedBooks;
}
@end

@implementation BookStore

// keys in CoreData
static const NSString *kEntityName = @"Book";
static const NSString *kName = @"name";
static const NSString *kAuthors = @"authors";
static const NSString *kImageHref = @"imageHref";
static const NSString *kDescription = @"bookDescription";
static const NSString *kAuthorInfo = @"authorInfo";
static const NSString *kPrice = @"price";
static const NSString *kPublisher = @"publisher";
static const NSString *kBookId = @"bookId";
static const NSString *kPublishDate = @"publishDate";

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

- (void)refreshStoredBooks
{
    storedBooks = [self fetchBooksFromStore];
}

- (BOOL)storeHasBook:(Book *)book
{
    for (NSManagedObject *storedBook in storedBooks) {
        if ([self book:storedBook isSameWithBook:book]) {
            return YES;
        }
    }
    return NO;
}

- (void)addBookToStore:(Book *)book
{
    NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [self setBookPropertiesByBook:book forManagedBook:newBook];
    
    NSArray *usersArray = [[UserStore sharedStore] storedUsersByUserId:[[UserStore sharedStore] currentUserId]];
    if ([usersArray count]) {
        NSManagedObject *currentUser = usersArray[0];
        NSMutableSet *booksSet = [currentUser mutableSetValueForKey:@"books"];
        [booksSet addObject:newBook];
    }
    
    [self saveContext];
    [[BookStore sharedStore] refreshStoredBooks];
}

#pragma mark - private methods

- (NSArray *)fetchBooksFromStore
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[UserStore sharedStore] currentUserId]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)kName ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (void)setBookPropertiesByBook:(Book *)book forManagedBook:(NSManagedObject *)managedBook
{
    [managedBook setValue:book.name forKey:(NSString *)kName];
    [managedBook setValue:book.authors forKey:(NSString *)kAuthors];
    [managedBook setValue:book.imageHref  forKey:(NSString *)kImageHref];
    [managedBook setValue:book.description forKey:(NSString *)kDescription];
    [managedBook setValue:book.authorInfo forKey:(NSString *)kAuthorInfo];
    [managedBook setValue:book.price forKey:(NSString *)kPrice];
    [managedBook setValue:book.publisher forKey:(NSString *)kPublisher];
    [managedBook setValue:book.bookId forKey:(NSString *)kBookId];
    [managedBook setValue:book.publishDate forKey:(NSString *)kPublishDate];
}

- (BOOL)book:(NSManagedObject *)storedBook isSameWithBook:(Book *)book
{
    return [[storedBook valueForKey:(NSString *)kName] isEqualToString:book.name]
    && [[storedBook valueForKey:(NSString *)kAuthors] isEqualToArray:book.authors];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [[self appDelegate] managedObjectContext];
}

- (void)saveContext
{
    [[self appDelegate] saveContext];
}

- (id)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

@end
