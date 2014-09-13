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


static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";
static const NSString *kBookId = @"douban_book_id";
static const NSString *kUserId = @"user_id";

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


@interface MyBooksTableViewController ()

@property (strong, nonatomic) UITableView *myBooksTableView;
@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) NSMutableArray *myBooks;
@property (strong, nonatomic) LoginViewController *loginController;
@property (assign, nonatomic) NSInteger bookCount;

@end

@implementation MyBooksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _myBooksTableView = self.tableView;
    
    UIStoryboard *mainStoryboard = self.storyboard;
    _loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserManager isLogin]) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
}

- (void)fetchBooksFromServer
{
    User *currentUser = [UserManager currentUser];
    NSString *currentUserId = currentUser.userId;

    NSString *getString = [kMyBooksURL stringByAppendingString:currentUserId];
    NSURL *getURL = [NSURL URLWithString:[getString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:getURL];
    
    [request setHTTPBody:[NSData data]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)showTableView
{
    [self loadData];
    self.view = _myBooksTableView;
    [_myBooksTableView reloadData];
    [self fetchBooksFromServer];
}

- (void)loadData
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
    cell.availabilityLabel.text = (book.availability == YES) ? (NSString *)kStatusYES : (NSString *)kStatusNO;
    return cell;
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        [AlertHelper showAlertWithMessage:@"验证失败" target:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (userObject) {
        [_myBooks removeAllObjects];
        NSArray *bookIdAndStatusArray = [userObject valueForKey:@"books"];
        _bookCount = [bookIdAndStatusArray count];
        for (id book in bookIdAndStatusArray) {
            
            NSString *bookId = [book valueForKey:(NSString *)kBookId];
            NSString *searchUrl = [NSString stringWithFormat:@"%@%@", kSearchBookId, bookId];
            NSString* encodedUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self bookFromDouBanWithUrl:encodedUrl];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [AlertHelper showAlertWithMessage:@"网络请求失败...\n请检查您的网络连接" target:self];
}

- (void)bookFromDouBanWithUrl:(NSString *)searchUrl
{
    [JsonDataFetcher dataFromURL:[NSURL URLWithString:searchUrl] withCompletion:^(NSData *jsonData) {
        id item = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        Book *book = [[Book alloc] init];
        book.name = [item valueForKey:(NSString *)kDBTitle];
        book.authors = [item valueForKey:(NSString *)kDBAuthor];
        book.imageHref = [item valueForKey:(NSString *)kDBImageHref];
        book.description = [item valueForKey:(NSString *)kDBSummary];
        book.authorInfo = [item valueForKey:(NSString *)kDBAuthorIntro];
        book.price = [item valueForKey:(NSString *)kDBPrice];
        book.publisher = [item valueForKey:(NSString *)kDBPublisher];
        book.publishDate = [item valueForKey:(NSString *)kDBPubdate];
        book.bookId = [item valueForKey:(NSString *)kDBBookId];
        
        [_myBooks addObject:book];
        _bookCount--;
        if (_bookCount == 0) {
            [self.tableView reloadData];
        }
    }];
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
