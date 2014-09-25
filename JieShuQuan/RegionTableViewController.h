//
//  RegionTableViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActivityIndicator.h"
@class User;

@interface RegionTableViewController : UITableViewController

@property (nonatomic, copy) NSMutableArray *provinceArray;
@property (nonatomic, copy) NSMutableArray *citiesArray;

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) User *currentUser;

@property (nonatomic, copy) NSString *changedLocation;
@property (nonatomic, copy) NSString *oldLocation;

- (void)disableBackButton;
- (void)enableBackButton;
- (void)popToControllerWithCountDownIndex:(NSInteger)index;
- (void)changeUserLocation:(NSString *)location andPopToControllerWithCountDownIndex:(NSInteger)index;

@end
