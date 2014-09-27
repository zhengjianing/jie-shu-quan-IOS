//
//  MyBooksTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "MyBooksTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "BookStore.h"
#import "UserManager.h"
#import "Book.h"
#import "BookTableViewCell.h"
#import "BookDetailTableViewController.h"
#import "ServerHeaders.h"
#import "AlertHelper.h"
#import "JsonDataFetcher.h"
#import "DoubanHeaders.h"
#import "User.h"
#import "RequestBuilder.h"
#import "DataConverter.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"


static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";

@interface MyBooksTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) LoginViewController *loginController;
@property (assign, nonatomic) NSInteger bookCount;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation MyBooksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchBooksFromServer) name:@"RefreshData" object:nil];
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self addRefreshControll];
    
    [self.tableView addSubview:self.messageLabel];
    [self.tableView addSubview:self.preLoginView];
    [self.tableView addSubview:self.activityIndicator];

    [self setTableFooterView];
    
    // Since viewDidLoad will only be called at launching, so refresh books at launching
    if ([UserManager isLogin]) {
        [_activityIndicator startAnimating];
        [self fetchBooksFromServer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self showTableView];
}

#pragma mark - initializing tableView accessories

- (UILabel *)messageLabel
{
    if (_messageLabel != nil) {
        return _messageLabel;
    }
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"您的书库暂时没书，您可以通过搜索来添加图书"];
    return _messageLabel;
}

- (PreLoginView *)preLoginView
{
    if (_preLoginView != nil) {
        return _preLoginView;
    }
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginView" owner:self options:nil];
    if ([topLevelObjs count] > 0)
    {
            _preLoginView = [topLevelObjs lastObject];
            _preLoginView.delegate = self;
    }
    return _preLoginView;
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)refreshData
{
    [self loadBooksFromStore];
    if (_myBooks.count > 0) {
        _messageLabel.hidden = YES;
    } else {
        _messageLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)showTableView
{
    if ([UserManager isLogin]) {
        _preLoginView.hidden = YES;
        [self refreshData];
    } else {
        _preLoginView.hidden = NO;
    }
}

- (void)loadBooksFromStore
{
    _myBooks = [[[BookStore sharedStore] storedBooks] mutableCopy];
}

#pragma mark - PreLoginView Delegate

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
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
    cell.authorsLabel.text = book.authors;
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    cell.availabilityLabel.text = (book.availability == YES) ? (NSString *)kStatusYES : (NSString *)kStatusNO;
    return cell;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_myBooks removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        // send delete request to server
    }
}

#pragma mark - fetch books from server

- (void)fetchBooksFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_activityIndicator stopAnimating];
        [_refresh endRefreshing];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" withAutoDismiss:YES];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_myBooks removeAllObjects];
            [[BookStore sharedStore] emptyBookStoreForCurrentUser];

            NSArray *booksArray = [responseObject valueForKey:@"books"];
            for (id item in booksArray) {
                Book *book = [DataConverter bookFromServerBookObject:item];
                [[BookStore sharedStore] addBookToStore:book];
            }
            [self refreshData];
        }
    }];
}

#pragma mark - pull to refresh

- (void)addRefreshControll
{
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refresh;
}

- (void)pullToRefresh:(UIRefreshControl *)refresh
{
    _messageLabel.hidden = YES;
    [self fetchBooksFromServer];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] class] == BookDetailTableViewController.class) {
        NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
        Book *selectedBook = [_myBooks objectAtIndex:[selectIndexPath row]];
        [[segue destinationViewController] setBook:selectedBook];
    }
}
- (IBAction)addBook:(id)sender {
    UIViewController *searchViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    [self.tabBarController setSelectedViewController:searchViewController];
}

@end
