//
//  UserStore.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/6/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "UserStore.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@implementation UserStore

// keys in DouBan API
static const NSString *kDouUserName = @"douban_user_name";
static const NSString *kDouAccessToken = @"access_token";
static const NSString *kDouUserId = @"douban_user_id";

// keys in NSUserDefaults
static const NSString *kUDCurrentUserName = @"current_username";
static const NSString *kUDAccessToken = @"access_token";
static const NSString *kUDUserId = @"user_id";

// keys in CoreData
static const NSString *kEntityName = @"User";
static const NSString *kDBUserId = @"user_id";
static const NSString *kDBAccessToken = @"access_token";

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
    NSString *userName = [userObject valueForKey:(NSString *)kDouUserName];
    NSString *accessToken = [userObject valueForKey:(NSString *)kDouAccessToken];
    NSString *userID = [userObject valueForKey:(NSString *)kDouUserId];
    
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:(NSString *)kUDCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:(NSString *)kUDAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:(NSString *)kUDUserId];
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:(NSString *)kEntityName inManagedObjectContext:[self managedObjectContext]];
    [user setValue:userID forKey:(NSString *)kDBUserId];
    [user setValue:accessToken forKey:(NSString *)kDBAccessToken];
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

#pragma mark - private methods

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
