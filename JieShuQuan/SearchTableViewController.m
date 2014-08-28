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
#import "JsonDataFetcher.h"
#import "DataConverter.h"
#import "Book.h"

@interface SearchTableViewController ()

- (void)searchKeywords:(NSString *)keywords;
- (void)fetchImageFromWebWithURL:(NSString *)imageURL forCell:(BookTableViewCell *)cell;

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[BookTableViewCell class] forCellReuseIdentifier:@"bookIdentifier"];
}

- (void)searchKeywords:(NSString *)keywords
{
    [JsonDataFetcher dataFromURL:[NSURL URLWithString:keywords] withCompletion:^(NSData *jsonData) {
        searchResults = [DataConverter booksArrayFromJsonData:jsonData];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
//    }
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bookIdentifier"];
    }
    // Configure the cell...
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Book *book = [searchResults objectAtIndex:indexPath.row];
//        if (tableView == self.searchDisplayController.searchResultsTableView) {
            cell.authorsLabel.text = [book authorsString];
            cell.nameLabel.text = book.name;
//            [self fetchImageFromWebWithURL:book.imageHref forCell:cell];
//        }
//    }
    return cell;
}

- (void)fetchImageFromWebWithURL:(NSString *)imageURL forCell:(BookTableViewCell *)cell
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imageData) {
                [cell.bookImageView setImage:[UIImage imageWithData:imageData]];
//                [self.tableView reloadData];
            }
        });
    });
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
