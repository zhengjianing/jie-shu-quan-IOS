//
//  MyBooksTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MyBooksTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyBooksTableViewController ()

@end

@implementation MyBooksTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的书";
    
    _myBooksTableView = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
}

- (void)showTableView
{
    [self loadData];
    self.view = _myBooksTableView;
}

- (void)loadData
{
    _sharedBookStore = [BookStore sharedStore];
    [_sharedBookStore createBooks];
    _myBooks = [_sharedBookStore allBooks];
}

#pragma mark - PreLoginView

- (void)login
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ningmengjia" forKey:@"username"];
    [self showTableView];
}

- (void)showPreLoginView
{
    if (!_preLoginView) {
        [self initPreLoginViewWithNib];
    }
    self.view = _preLoginView;
}

- (void)initPreLoginViewWithNib
{
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginNib" owner:self options:nil];
    if ([topLevelObjs count] > 0)
    {
        _preLoginView = [topLevelObjs lastObject];
        _preLoginView.delegate = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookIdentifier" forIndexPath:indexPath];
    Book *book = [_myBooks objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = book.name;
    cell.authorsLabel.text = [book authorsString];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectIndexPath = nil;
    Book *selectedBook = nil;

    if ([[segue destinationViewController] class] == BookDetailViewController.class) {
        selectIndexPath = [self.tableView indexPathForSelectedRow];
        selectedBook = [_myBooks objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setBook:selectedBook];
    }
}

@end
