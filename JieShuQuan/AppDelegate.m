//
//  AppDelegate.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareSDK/Extend/WeChatSDK/WXApi.h"
#import "SearchTableViewController.h"
#import "MyBooksTableViewController.h"
#import "FriendsTableViewController.h"
#import "MoreTableViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
#import "TabBarItemHelper.h"
#import "WXApi.h"
#import "CustomColor.h"

@implementation AppDelegate
            
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:@"5427f7a4fd98c566c80090e6" reportPolicy:BATCH channelId:nil];
    
    [ShareSDK registerApp:@"3456b138a03c"];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx6a876af68c7eb3fe" wechatCls:[WXApi class]];
    
    UITabBarController *tabBarController = [self createTabBarController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (UITabBarController *)createTabBarController
{
    UINavigationController *searchNavController = [self createNavControllerWithIdentifier:@"searchViewController" tabBarTitle:@"搜索" iconFont:[FAKIonIcons androidSearchIconWithSize:19]];
    UINavigationController *myBookNavController = [self createNavControllerWithIdentifier:@"myBooksViewController" tabBarTitle:@"我的书库" iconFont:[FAKIonIcons androidBookIconWithSize:19]];
    UINavigationController *friendsNavController = [self createNavControllerWithIdentifier:@"friendsTableViewController" tabBarTitle:@"同事们" iconFont:[FAKIonIcons ios7PeopleIconWithSize:31]];
    UINavigationController *moreNavController = [self createNavControllerWithIdentifier:@"moreTableViewController" tabBarTitle:@"更多" iconFont:[FAKIonIcons moreIconWithSize:28]];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:searchNavController, myBookNavController, friendsNavController, moreNavController, nil]];
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [tabBarController.tabBar setSelectedImageTintColor:[CustomColor mainGreenColor]];

    return tabBarController;
}

- (UINavigationController *)createNavControllerWithIdentifier:(NSString *)identifier tabBarTitle:(NSString *)title iconFont:(FAKIonIcons *)iconFont
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    viewController.tabBarItem = [TabBarItemHelper createTabBarItemWithTitle:title icon:iconFont];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navController;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JieShuQuan" withExtension:@"momd"];
    NSLog(@"%@", modelURL.absoluteString);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JieShuQuan.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    
    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
