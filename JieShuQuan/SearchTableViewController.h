//
//  SearchTableViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-28.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchDisplayDelegate>
{
    NSMutableArray *searchResults;
}
@end
