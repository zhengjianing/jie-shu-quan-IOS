//
//  Store.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/7/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Store : NSObject

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;
- (id)appDelegate;

@end
