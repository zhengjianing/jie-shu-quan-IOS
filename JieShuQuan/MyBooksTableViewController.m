//
//  MyBooksTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MyBooksTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreData/CoreData.h>
//#import "AppDelegate.h"
#import "LoginViewController.h"


@interface MyBooksTableViewController ()

@end

@implementation MyBooksTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的书";
    
    _myBooksTableView = self.tableView;
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];
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
    [_myBooksTableView reloadData];
}

- (void)loadData
{
    _myBooks = [self fetchBooksFromStore];
}

#pragma mark - PreLoginView

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
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

- (NSArray *)fetchBooksFromStore
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSArray *booksArray = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    booksArray = [context executeFetchRequest:request error:&error];
    if (!booksArray) {
        NSLog(@"Fetch Cache Failed: %@, %@", error, [error userInfo]);
    }
    return booksArray;

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
    id book = [_myBooks objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [book valueForKey:@"name"];
    cell.authorsLabel.text = [[book valueForKey:@"authors"] componentsJoinedByString:@", "];
    [cell.bookImageView setImage:[UIImage imageWithData:[book valueForKey:@"imageData"]]];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectIndexPath = nil;
    Book *selectedBook = nil;

    if ([[segue destinationViewController] class] == BookDetailViewController.class) {
        selectIndexPath = [self.tableView indexPathForSelectedRow];
        selectedBook = [_myBooks objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setBook:selectedBook];
        [[[segue destinationViewController] navigationItem] setRightBarButtonItem:nil];
    }
}

@end
