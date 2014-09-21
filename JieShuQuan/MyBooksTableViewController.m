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
#import "ViewHelper.h"


static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";

@interface MyBooksTableViewController ()

@property (strong, nonatomic) UITableView *myBooksTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) LoginViewController *loginController;
@property (assign, nonatomic) NSInteger bookCount;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation MyBooksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchBooksFromServer) name:@"RefreshData" object:nil];
    
    _myBooksTableView = self.tableView;
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self addRefreshControll];
    
    [self addMessageLabel];
    [self initPreLoginViewWithNib];
    
    [self removeUnneccessaryCells];
    [self initActivityIndicator];
    
    // Since viewDidLoad will only be called at launching, so refresh books at launching
    if ([UserManager isLogin]) {
        [_activityIndicator startAnimating];
        [self fetchBooksFromServer];
    }
}

- (void)refreshView
{
    self.view = _myBooksTableView;
    if (_myBooks.count > 0) {
        _messageLabel.hidden = YES;
    } else {
        _messageLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    if ([UserManager isLogin]) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
}

#pragma mark -- initializing view

- (void)showTableView
{
    [self loadBooksFromStore];
    [self refreshView];
}

- (void)addMessageLabel
{
    _messageLabel = [ViewHelper createMessageLableWithMessage:@"您的书库暂时没书，您可以通过搜索来添加图书"];
    [self.view addSubview:_messageLabel];
}

- (void)removeUnneccessaryCells
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)initActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
}

- (void)loadBooksFromStore
{
    _myBooks = [[[BookStore sharedStore] storedBooks] mutableCopy];
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
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginView" owner:self options:nil];
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
    cell.authorsLabel.text = book.authors;
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    cell.availabilityLabel.text = (book.availability == YES) ? (NSString *)kStatusYES : (NSString *)kStatusNO;
    return cell;
}

#pragma mark - fetch books from server

- (void)fetchBooksFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_activityIndicator stopAnimating];
        [_refresh endRefreshing];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" withAutoDismiss:YES target:self];
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
            [self showTableView];
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

@end
