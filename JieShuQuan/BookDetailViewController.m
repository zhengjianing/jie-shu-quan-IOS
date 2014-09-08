//
//  BookDetailViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BookStore.h"
#import "Book.h"
#import "AlertHelper.h"

static const NSString *kAddBookURL = @"http://jie-shu-quan.herokuapp.com/add_book";
static const NSString *kBookId = @"douban_book_id";
static const NSString *kAvailableState = @"available";

// keys in NSUserDefaults
static const NSString *kUDCurrentUserName = @"current_username";
static const NSString *kUDGroupName = @"group_name";
static const NSString *kUDAccessToken = @"access_token";
static const NSString *kUDUserId = @"user_id";

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _addBookButton.layer.cornerRadius = 5.0;
    _borrowFromFriends.layer.cornerRadius = 5.0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
   
}

- (IBAction)addBook:(id)sender {
    if ([[BookStore sharedStore] storeHasBook:_book]) {
        [AlertHelper showAlertWithMessage:@"我的书库已有此书" target:self];
    } else {
        [AlertHelper showAlertWithMessage:@"已添加至我的书库" target:self];
        [self postRequestWithBookId:_book.bookId available:YES
                             userId:[[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kUDUserId]
                         accessToke:[[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kUDAccessToken]];
        [[BookStore sharedStore] addBookToStore:_book];
    }
}

- (void)postRequestWithBookId:(NSString *)bookId available:(BOOL)state userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:state], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    NSURL *postURL = [NSURL URLWithString:[kAddBookURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", userObject);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", @"connectionDidFinishLoading");
}


@end
