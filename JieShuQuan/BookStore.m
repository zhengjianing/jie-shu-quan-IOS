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

@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, weak) id appDelegate;

- (NSArray *)fetchBooksFromStore;
- (void)saveContext;

@end

@implementation BookStore

// keys in CoreData
static const NSString *kEntityName = @"Book";
static const NSString *kName = @"name";
static const NSString *kAuthors = @"authors";
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

- (void)refreshStore
{
    storedBooks = [self fetchBooksFromStore];
}

- (BOOL)storeHasBook:(Book *)book
{
    for (NSManagedObject *item in storedBooks) {
        if ([[item valueForKey:@"name"] isEqualToString:book.name]
            && [[item valueForKey:@"authors"] isEqualToArray:book.authors]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)fetchBooksFromStore
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[UserStore sharedStore] currentUserId]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)kName ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (void)addBookToStore:(Book *)book
{
    NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    
    [newBook setValue:book.name forKey:(NSString *)kName];
    [newBook setValue:book.authors forKey:(NSString *)kAuthors];
    //    [newBook setValue:UIImageJPEGRepresentation(_bookImageView.image, 1.0)  forKey:@"imageData"];
    [newBook setValue:book.description forKey:(NSString *)kDescription];
    [newBook setValue:book.authorInfo forKey:(NSString *)kAuthorInfo];
    [newBook setValue:book.price forKey:(NSString *)kPrice];
    [newBook setValue:book.publisher forKey:(NSString *)kPublisher];
    [newBook setValue:book.bookId forKey:(NSString *)kBookId];
    [newBook setValue:book.publishDate forKey:(NSString *)kPublishDate];
    
    NSArray *usersArray = [[UserStore sharedStore] usersByUserId:[[UserStore sharedStore] currentUserId]];
    if ([usersArray count]) {
        NSManagedObject *currentUser = usersArray[0];
        NSMutableSet *booksSet = [currentUser mutableSetValueForKey:@"books"];
        [booksSet addObject:newBook];
        [self saveContext];
        
        [[BookStore sharedStore] refreshStore];
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedContext) {
        _managedContext = [[self appDelegate] managedObjectContext];
    }
    return _managedContext;
}

- (id)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (void)saveContext
{
    [_appDelegate saveContext];
}

@end
