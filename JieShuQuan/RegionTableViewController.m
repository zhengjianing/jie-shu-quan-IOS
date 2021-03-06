//
//  RegionTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "RegionTableViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "SettingsTableViewController.h"
#import "CustomAlert.h"
#import "CustomActivityIndicator.h"

@interface RegionTableViewController ()

@end

@implementation RegionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableFooterView];
    _currentUser = [UserManager currentUser];
    
    [self setRegionData];
}

- (void)setRegionData
{
    _provinceArray = [[NSMutableArray alloc] init];
    _citiesArray = [[NSMutableArray alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *plistPath = [mainBundle pathForResource:@"city" ofType:@"plist"];
    
    NSArray *regionArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (id state in regionArray) {
        [_provinceArray addObject:[state valueForKey:@"state"]];
        [_citiesArray addObject:[state valueForKey:@"cities"]];
    }
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)disableBackButton
{
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
}

- (void)enableBackButton
{
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
}

- (void)popToControllerWithCountDownIndex:(NSInteger)index
{
    NSArray *navStack = [self.navigationController viewControllers];
    id viewController = [navStack objectAtIndex:(navStack.count-index)];
    [self.navigationController popToViewController:viewController animated:YES];
}

- (void)changeUserLocation:(NSString *)location andPopToControllerWithCountDownIndex:(NSInteger)index
{
    NSMutableURLRequest *request = [RequestBuilder buildChangeUserLocationRequestWithUserId:_currentUser.userId accessToken:_currentUser.accessToken location:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [self enableBackButton];
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改位置失败"];
        }
        if (data) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改位置成功"];
            _currentUser.location = location;
            [[UserStore sharedStore] saveUserToCoreData:_currentUser];
            
            [self popToControllerWithCountDownIndex:index];
        }
    }];
}

@end
