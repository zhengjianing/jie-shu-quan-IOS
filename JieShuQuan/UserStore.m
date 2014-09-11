//
//  UserStore.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "UserStore.h"
#import <CoreData/CoreData.h>
#import "User.h"

@interface UserStore ()
{
    User *currentUser;
}
@end

@implementation UserStore

// keys in Server API
static const NSString *kUserName = @"user_name";
static const NSString *kGroupName = @"group_name";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";
static const NSString *kUserEmail = @"user_email";

// keys in NSUserDefaults
static const NSString *kUDCurrentUser = @"current_user";

// keys in CoreData
static const NSString *kEntityName = @"User";
static const NSString *kDBUserId = @"user_id";
static const NSString *kDBUserName = @"user_name";
static const NSString *kDBGroupName = @"group_name";

+ (UserStore *)sharedStore
{
    static UserStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (void)saveUserWithObject:(id)userObject
{
    currentUser = [self userFromObject:userObject];
    [self saveUserToUserDefaults:currentUser];
    [self saveUserToCoreData:currentUser];
}


- (User *)userFromObject:(id)object
{
    User *user = [[User alloc] init];
    if ([object class] == [NSDictionary class]) {
        user.name = [object valueForKey:(NSString *)kUserName];
        user.groupName = [object valueForKey:(NSString *)kGroupName];
        user.accessToken = [object valueForKey:(NSString *)kAccessToken];
        user.userId = [object valueForKey:(NSString *)kUserId];
        user.email = [object valueForKey:(NSString *)kUserEmail];
    }
    return user;
}

#pragma mark - Core Data

- (void)saveUserToCoreData:(User *)user
{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [managedObject setValue:user.userId forKey:(NSString *)kDBUserId];
    [managedObject setValue:user.name forKey:(NSString *)kDBUserName];
    [managedObject setValue:user.groupName forKey:(NSString *)kDBGroupName];
    [self saveContext];
}

- (NSArray *)storedUsersWithUserId:(NSString *)userId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    //此处不能用kDBUserId代替Format中的user_id
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@", userId];
    [request setPredicate:predicate];
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}


#pragma mark - NSUserDefaults

- (void)saveUserToUserDefaults:(User *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:(NSString *)kUDCurrentUser];
}

- (NSString *)currentUserId
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDCurrentUser] userId];
}

- (NSString *)currentUserName
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDCurrentUser] name];
}

- (void)removeCurrentUserFromUD
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDCurrentUser];
}

@end
