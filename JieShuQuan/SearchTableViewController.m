//
//  SearchTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-27.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "BookTableViewCell.h"
#import "DoubanHeaders.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)searchKeywords:(NSString *)keywords
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bookIdentifier";
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *prefix = [NSString stringWithFormat:@"%@?apikey=%@&q=", kSearchURL, kAPIKey];
    [self searchKeywords:[prefix stringByAppendingString:searchString]];
    return YES;
}


@end
