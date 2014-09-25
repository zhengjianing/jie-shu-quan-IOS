//
//  CityTableViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-24.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionTableViewController.h"

@interface CityTableViewController : RegionTableViewController

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSArray *cityArray;

@end
