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
#import "UserManager.h"
#import "User.h"

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
static const NSString *kAvailability = @"availability";

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
        storedBooks = [self booksArrayFromStore:[self fetchBooksFromStore]];
    }
    return self;
}

- (NSArray *)storedBooks
{
    return storedBooks;
}

- (void)refreshStoredBooks
{
    storedBooks = [self booksArrayFromStore:[self fetchBooksFromStore]];
}

- (BOOL)storeHasBook:(Book *)book
{
    for (Book *item in storedBooks) {
        if ([item isSameBook:book]) {
            return YES;
        }
    }
    return NO;
}

- (void)addBookToStore:(Book *)book
{
    NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [self setBookPropertiesByBook:book forManagedBook:newBook];
    
    User *user = [UserManager currentUser];
    NSArray *usersArray = [[UserStore sharedStore] storedUsersWithUserId:[user userId]];
    if ([usersArray count]) {
        NSManagedObject *currentUser = usersArray[0];
        NSMutableSet *booksSet = [currentUser mutableSetValueForKey:@"books"];
        [booksSet addObject:newBook];
    }
    
    [self saveContext];
    [[BookStore sharedStore] refreshStoredBooks];
}

- (void)changeStoredBookStatusWith:(Book *)book
{
    NSArray *booksArray = [self fetchBooksFromStore];
    for (id item in booksArray) {
        if ([book.bookId isEqualToString:[item valueForKey:(NSString *)kBookId]]) {
            [item setValue:[NSNumber numberWithBool:book.availability] forKey:(NSString *)kAvailability];
            [self saveContext];
            [[BookStore sharedStore] refreshStoredBooks];
            return;
        }
    }
}

#pragma mark - private methods

- (NSArray *)fetchBooksFromStore
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[UserManager currentUser] userId]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)kName ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (NSMutableArray *)booksArrayFromStore:(NSArray *)array
{
    NSMutableArray *booksArray = [NSMutableArray array];
    NSArray *storedArray = [self fetchBooksFromStore];
    for (NSManagedObject *storedBook in storedArray) {
        Book *book = [[Book alloc] init];
        book.name = [storedBook valueForKey:(NSString *)kName];
        book.authors = [storedBook valueForKey:(NSString *)kAuthors];
        book.imageHref = [storedBook valueForKey:(NSString *)kImageHref];
        book.description = [storedBook valueForKey:(NSString *)kDescription];
        book.authorInfo = [storedBook valueForKey:(NSString *)kAuthorInfo];
        book.price = [storedBook valueForKey:(NSString *)kPrice];
        book.publisher = [storedBook valueForKey:(NSString *)kPublisher];
        book.bookId = [storedBook valueForKey:(NSString *)kBookId];
        book.publishDate = [storedBook valueForKey:(NSString *)kPublishDate];
        book.availability = [[storedBook valueForKey:(NSString *)kAvailability] boolValue];
        
        [booksArray addObject:book];
    }
    return booksArray;
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

@end
