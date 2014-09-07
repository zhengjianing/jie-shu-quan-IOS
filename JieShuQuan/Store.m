//
//  Store.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/7/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "Store.h"
#import "AppDelegate.h"

@implementation Store

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
