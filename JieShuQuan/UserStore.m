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

@implementation UserStore

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

@end
