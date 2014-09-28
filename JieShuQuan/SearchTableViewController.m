//
//  SearchTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-8-28.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "BookDetailTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "DoubanHeaders.h"
#import "JsonDataFetcher.h"
#import "DataConverter.h"
#import "Book.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"
#import "MobClick.h"

@interface SearchTableViewController ()

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
- (void)searchByDouBanWithUrl:(NSString *)searchUrl;

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotifications];
    [self setTableFooterView];
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];
    
    [self setExtraCellLineHidden:self.searchDisplayController.searchResultsTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    [MobClick beginLogPageView:@"searchPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"searchPage"];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSearch) name:@"resetSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webDataFetchFailed) name:@"webDataFetchFailed" object:nil];
}

- (void)resetSearch
{
    [self.searchDisplayController setActive:NO];
    searchResults = nil;
    [self.tableView reloadData];
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)webDataFetchFailed
{
    [[CustomAlert sharedAlert] showAlertWithMessage:@"数据获取失败...请检查您的网络"];
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)searchByDouBanWithUrl:(NSString *)searchUrl
{
    [JsonDataFetcher dataFromURL:[NSURL URLWithString:searchUrl] withCompletion:^(NSData *jsonData) {
        searchResults = [DataConverter booksArrayFromDoubanSearchResults:jsonData];
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
    SearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchIdentifier"];
    if (!cell) {
        cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchIdentifier"];
    }
    
    Book *book = [searchResults objectAtIndex:indexPath.row];
    cell.nameLabel.text = book.name;
    cell.authorsLabel.text = book.authors;
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (![searchString isEqualToString:@""]) {
        NSString *prefix = [NSString stringWithFormat:@"%@?apikey=%@&count=%@&q=", kSearchURL, kAPIKey, kMaxCount];
        NSString *searchUrl = [prefix stringByAppendingString:searchString];
        NSString* encodedUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self searchByDouBanWithUrl:encodedUrl];
    }
    return NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectIndexPath = nil;
    Book *selectedBook = nil;
    
    if ([[segue destinationViewController] class] == BookDetailTableViewController.class) {
        selectIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        selectedBook = [searchResults objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setBook:selectedBook];
//        [[[segue destinationViewController] changeAvailabilityButton] removeFromSuperview];
    }
}

#pragma mark - zBar scanner

- (IBAction)startScan:(id)sender
{
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//    
//    [self presentViewController:reader animated:YES completion:nil];
}

//- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results) {
//        // EXAMPLE: just grab the first barcode
//        break;
//    }
//    
//    NSString *isbnCode = symbol.data;
//    if (isbnCode) {
////        [self startFetchingBookDetailFromDoubanWithIsbnCode:isbnCode];
//            [_activityIndicator startAnimating];
//    } else {
//        [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书信息失败"];

//    }
//    
//    [reader dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)startFetchingBookDetailFromDoubanWithIsbnCode:(NSString *)isbnCode
//{
//    NSString *isbnUrlString = [NSString stringWithFormat:@"%@?apikey=%@", [kSearchIsbnCode stringByAppendingString:isbnCode], kAPIKey];
//    NSString* encodedUrl = [isbnUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [JsonDataFetcher dataFromURL:[NSURL URLWithString:encodedUrl] withCompletion:^(NSData *jsonData) {
//        [_activityIndicator stopAnimating];
//
//        id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//        if (object) {
//            Book *book = [DataConverter bookFromDoubanBookObject:object];
//            [self showBookDetailViewControllerForBook:book];
//        } else {
//        [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书信息失败"];

//        }
//    }];
//}
//
//- (void)showBookDetailViewControllerForBook:(Book *)book
//{
//    UIStoryboard *mainStoryboard = self.storyboard;
//    BookDetailTableViewController *bookDetailTableViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
//
//    [bookDetailTableViewController setBook:book];
//    [self.navigationController pushViewController:bookDetailTableViewController animated:YES];
//}

@end
