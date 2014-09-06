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

@interface UserStore()
{
    NSManagedObjectContext *context;
    id appDelegate;
}
@end

// keys in NSUserDefaults
static NSString *kCurrentUserName = @"current_username";
static NSString *kAccessToken = @"access_token";
static NSString *kUserId = @"user_id";
static NSString *kEntityName = @"User";

@implementation UserStore

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

- (void)saveCurrentUserByName:(NSString *)userName accessToken:(NSString *)accessToken userId:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserId];
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:[self managedObjectContext]];
    [user setValue:userID forKey:@"user_id"];
    [user setValue:accessToken forKey:@"access_token"];
    [self saveContext];
}

- (NSArray *)usersByUserId:(NSString *)userId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", [[UserStore sharedStore] currentUserId]];
    [request setPredicate:predicate];
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

- (NSString *)currentUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
}

- (NSString *)currentUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserName];
}

- (void)removeCurrentUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserId];
}

- (void)saveContext
{
    [[self appDelegate] saveContext];
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (!context) {
        context = [[self appDelegate] managedObjectContext];
    }
    return context;
}

- (id)appDelegate
{
    if (!appDelegate) {
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return appDelegate;
}

@end
