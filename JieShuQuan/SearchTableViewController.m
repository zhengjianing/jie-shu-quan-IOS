//
//  SearchTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-28.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "BookTableViewCell.h"
#import "DoubanHeaders.h"
#import "JsonDataFetcher.h"
#import "DataConverter.h"
#import "Book.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchTableViewController ()

- (void)searchKeywords:(NSString *)keywords;
- (void)fetchImageFromWebWithURL:(NSString *)imageURL forCell:(BookTableViewCell *)cell;

@end

@implementation SearchTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)searchKeywords:(NSString *)keywords
{
    [JsonDataFetcher dataFromURL:[NSURL URLWithString:keywords] withCompletion:^(NSData *jsonData) {
        searchResults = [DataConverter booksArrayFromJsonData:jsonData];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchIdentifier"];
    if (!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchIdentifier"];
    }
    
    Book *book = [searchResults objectAtIndex:indexPath.row];
    cell.nameLabel.text = book.name;
    cell.authorsLabel.text = [book authorsString];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (![searchString isEqualToString:@""]) {
        NSString *prefix = [NSString stringWithFormat:@"%@?apikey=%@&count=10&q=", kSearchURL, kAPIKey];
        [self searchKeywords:[prefix stringByAppendingString:searchString]];
    }
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[BookTableViewCell class] forCellReuseIdentifier:@"searchIdentifier"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
