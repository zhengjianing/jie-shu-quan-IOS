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
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerClass:[BookTableViewCell class] forCellReuseIdentifier:@"searchIdentifier"];
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchIdentifier" forIndexPath:indexPath];
    // different from that in 'MyBooksTableViewController.m', figure out later
    if (!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchIdentifier"];
    }
    
    Book *book = [searchResults objectAtIndex:indexPath.row];
    //        cell.authorsLabel.text = [book authorsString];
    //        cell.nameLabel.text = book.name;
    cell.textLabel.text = book.name;
    NSLog(@"%@", cell.textLabel.text);
    //        [self fetchImageFromWebWithURL:book.imageHref forCell:cell];
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

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *prefix = [NSString stringWithFormat:@"%@?apikey=%@&q=", kSearchURL, kAPIKey];
    [self searchKeywords:[prefix stringByAppendingString:searchString]];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
