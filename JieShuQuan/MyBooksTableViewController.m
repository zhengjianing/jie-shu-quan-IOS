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
#import "JsonDataFetcher.h"
#import "DoubanHeaders.h"
#import "User.h"
#import "RequestBuilder.h"
#import "DataConverter.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"
#import "UserStore.h"
#import "CustomAlert.h"
#import "MobClick.h"
#import <FontAwesomeKit/FAKIonIcons.h>

static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂不可借";

@interface MyBooksTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) LoginViewController *loginController;
@property (assign, nonatomic) NSInteger bookCount;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) UILabel *messageLabel;

@property (assign, nonatomic) BOOL isFirstLaunch;
@end

@implementation MyBooksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchBooksFromServer) name:@"RefreshData" object:nil];
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.tableView addSubview:self.messageLabel];
    _messageLabel.hidden = YES;
    [self.tableView addSubview:self.preLoginView];

    [self setTableFooterView];
    
    // Since viewDidLoad will only be called at launching, so refresh books at launching
    if ([UserManager isLogin]) {
        [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
        [self fetchBooksFromServer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self showTableView];
    
    [MobClick beginLogPageView:@"myBooksPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"myBooksPage"];
    [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
}

- (void)showTableView
{
    if ([UserManager isLogin]) {
        _preLoginView.hidden = YES;
        [self addRefreshControll];
        [self refreshData];
    } else {
        _preLoginView.hidden = NO;
        self.refreshControl = nil;
    }
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

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
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
        if (indexPath.row < _myBooks.count) {
            [self deleteBook:[_myBooks objectAtIndex:indexPath.row] atIndexPath:indexPath];
        }
    }
}

#pragma mark - delete book

- (void)deleteBook:(Book *)book atIndexPath:(NSIndexPath *)indexPath
{
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];

    NSMutableURLRequest *deleteBookRequest = [RequestBuilder buildDeleteBookRequestWithBookId:book.bookId userId:[[UserManager currentUser] userId] accessToke:[[UserManager currentUser] accessToken]];
    
    [NSURLConnection sendAsynchronousRequest:deleteBookRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"删除图书失败"];
        }
        
        if (data) {
            [_myBooks removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [[BookStore sharedStore] deleteBookFromStore:book];
            [[UserStore sharedStore] decreseBookCountForUser:[[UserManager currentUser] userId]];
        }
        
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [self.tableView setEditing:NO];
    }];

}

#pragma mark - fetch books from server

- (void)fetchBooksFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [_refresh endRefreshing];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"更新失败"];
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

@end
