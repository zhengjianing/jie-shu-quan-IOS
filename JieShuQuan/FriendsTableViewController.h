//
//  FriendsTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreLoginView.h"

@interface FriendsTableViewController : UITableViewController <PreLoginDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
