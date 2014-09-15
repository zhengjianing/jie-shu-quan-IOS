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


static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";
static const NSString *kUserId = @"user_id";
static const NSString *kAvailability = @"available";

// keys in Douban API
static const NSString *kDBTitle = @"title";
static const NSString *kDBAuthor = @"author";
static const NSString *kDBImageHref = @"image";
static const NSString *kDBSummary = @"summary";
static const NSString *kDBAuthorIntro = @"author_intro";
static const NSString *kDBPrice = @"price";
static const NSString *kDBPublisher = @"publisher";
static const NSString *kDBPubdate = @"pubdate";
static const NSString *kDBBookId = @"id";

// keys in Server
static const NSString *kBookname = @"name";
static const NSString *kBookauthors = @"authors";
static const NSString *kBookimageHref = @"image_href";
static const NSString *kBookdescription = @"description";
static const NSString *kBookauthorInfo = @"author_info";
static const NSString *kBookprice = @"price";
static const NSString *kBookpublisher = @"publisher";
static const NSString *kBookpublishDate = @"publish_date";
static const NSString *kBookId = @"douban_book_id";
static const NSString *kBookAvailable = @"available";


@interface MyBooksTableViewController ()

@property (strong, nonatomic) UITableView *myBooksTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) LoginViewController *loginController;
@property (assign, nonatomic) NSInteger bookCount;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (copy, nonatomic) NSMutableArray *tempArray;

@end

@implementation MyBooksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myBooksTableView = self.tableView;
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self addRefreshControll];
    _tempArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserManager isLogin]) {
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
    _myBooks = [[[BookStore sharedStore] storedBooks] mutableCopy];
}

#pragma mark -- pull to refresh
- (void)addRefreshControll
{
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refresh;
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    [self fetchBooksFromServer];
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

#pragma mark -- fetch books from server

- (void)fetchBooksFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:[[UserManager currentUser] userId]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"验证失败" target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            NSArray *booksArray = [responseObject valueForKey:@"books"];
            _bookCount = [booksArray count];
            for (id book in booksArray) {
                [_tempArray addObject:book];
                _bookCount--;
                if (_bookCount == 0) {
                    [self saveServerBooksToBookStore];
                }
            }
        }
    }];
}


- (void)saveServerBooksToBookStore
{
    [_myBooks removeAllObjects];
    [[BookStore sharedStore] emptyBookStoreForCurrentUser];
    for (id item in _tempArray) {
        Book *book = [[Book alloc] init];
        
        book.name = [item valueForKey:(NSString *)kBookname];
        book.authors = [item valueForKey:(NSString *)kBookauthors];
        book.imageHref = [item valueForKey:(NSString *)kBookimageHref];
        book.description = [item valueForKey:(NSString *)kBookdescription];
        book.authorInfo = [item valueForKey:(NSString *)kBookauthorInfo];
        book.price = [item valueForKey:(NSString *)kBookprice];
        book.publisher = [item valueForKey:(NSString *)kBookpublisher];
        book.publishDate = [item valueForKey:(NSString *)kBookpublishDate];
        book.bookId = [item valueForKey:(NSString *)kBookId];
        book.availability = [[item valueForKey:(NSString *)kBookAvailable] boolValue];
        
        //必须要做类型转换，不然在BookStore的setPropertiesByBook:方法里面会报错，因为是NSCFDictionary类型
        
        [[BookStore sharedStore] addBookToStore:book];
    }
    [self loadData];
    [self.tableView reloadData];
    [self updateRefreshControll];
}

- (void)updateRefreshControll
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    _refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(endRefreshing) userInfo:nil repeats:NO];
}

- (void)endRefreshing {
    [_refresh endRefreshing];
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
