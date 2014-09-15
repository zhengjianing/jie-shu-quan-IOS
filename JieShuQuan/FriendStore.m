//
//  FriendStore.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendStore.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "Friend.h"
#import "DataConverter.h"

@interface FriendStore ()
{
    NSArray *storedFriends;
}
@end

@implementation FriendStore

// keys in CoreData
static const NSString *kEntityName = @"Friend";
static const NSString *kCDFriendBookCount = @"book_count";

+ (FriendStore *)sharedStore
{
    static FriendStore *sharedStore = nil;
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
        storedFriends = [self friendsArrayFromStore:[self fetchFriendsFromStore]];
    }
    return self;
}

- (NSArray *)storedFriends
{
    return storedFriends;
}

- (void)refreshStoredFriends
{
    storedFriends = [self friendsArrayFromStore:[self fetchFriendsFromStore]];
}

- (void)addFriendToStore:(Friend *)friend
{
    NSManagedObject *newFriend = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [self setFriendPropertiesByFriend:friend forManagedFriend:newFriend];
    
    User *user = [UserManager currentUser];
    NSArray *usersArray = [[UserStore sharedStore] storedUsersWithUserId:[user userId]];
    if ([usersArray count]) {
        NSManagedObject *currentUser = usersArray[0];
        NSMutableSet *friendSet = [currentUser mutableSetValueForKey:@"friends"];
        [friendSet addObject:newFriend];
    }
    
    [self saveContext];
    [[FriendStore sharedStore] refreshStoredFriends];
}

- (void)emptyFriendStoreForCurrentUser
{
    NSArray *userFriends = [self fetchFriendsFromStore];
    for (NSManagedObject *friend in userFriends) {
        [[self managedObjectContext] deleteObject:friend];
    }
    [self saveContext];
}

#pragma mark - private methods

- (NSArray *)fetchFriendsFromStore
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.user_id == %@", [[UserManager currentUser] userId]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)kCDFriendBookCount ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (NSMutableArray *)friendsArrayFromStore:(NSArray *)array
{
    NSMutableArray *friendsArray = [NSMutableArray array];
    for (NSManagedObject *storedFriend in array) {
        Friend *friend = [DataConverter friendFromStore:storedFriend];
        [friendsArray addObject:friend];
    }
    return friendsArray;
}

- (void)setFriendPropertiesByFriend:(Friend *)friend forManagedFriend:(NSManagedObject *)managedFriend
{
    [DataConverter setManagedObject:managedFriend forFriend:friend];
}

@end