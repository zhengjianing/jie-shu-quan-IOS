//
//  UserStore.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "UserStore.h"
#import <CoreData/CoreData.h>

@implementation UserStore

// keys in Server API
static const NSString *kUserName = @"user_name";
static const NSString *kGroupName = @"group_name";
static const NSString *kAccessToken = @"access_token";
static const NSString *kUserId = @"user_id";

// keys in NSUserDefaults
static const NSString *kUDCurrentUserName = @"current_username";
static const NSString *kUDGroupName = @"group_name";
static const NSString *kUDAccessToken = @"access_token";
static const NSString *kUDUserId = @"user_id";

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

- (void)saveCurrentUserToUDAndDBByUserObject:(id)userObject
{
    //get user from server
    NSString *userName = [userObject valueForKey:(NSString *)kUserName];
    NSString *groupName = [userObject valueForKey:(NSString *)kGroupName];
    NSString *accessToken = [userObject valueForKey:(NSString *)kAccessToken];
    NSString *userID = [userObject valueForKey:(NSString *)kUserId];
    
    //save user to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:(NSString *)kUDCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:(NSString *)kUDGroupName];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:(NSString *)kUDAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:(NSString *)kUDUserId];
    
    //save user to database
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [user setValue:userID forKey:(NSString *)kDBUserId];
    [user setValue:userName forKey:(NSString *)kDBUserName];
    [user setValue:groupName forKey:(NSString *)kDBGroupName];
    [self saveContext];
}

- (NSArray *)storedUsersByUserId:(NSString *)userId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:(NSString *)kEntityName];
    //此处不能用kDBUserId代替Format中的user_id
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@", userId];
    [request setPredicate:predicate];
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (NSString *)currentUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDUserId];
}

- (NSString *)currentUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUDCurrentUserName];
}

- (void)removeCurrentUserFromUD
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDCurrentUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kUDUserId];
}

@end
