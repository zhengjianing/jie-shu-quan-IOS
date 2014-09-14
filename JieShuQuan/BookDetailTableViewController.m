//
//  BookDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/13/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookDetailTableViewController.h"
#import "Book.h"
#import "SearchTableViewController.h"
#import "MyBooksTableViewController.h"
#import "BookStore.h"
#import "AlertHelper.h"
#import "User.h"
#import "UserManager.h"
#import "UserStore.h"
#import "ServerHeaders.h"

static const NSString *kBookId = @"douban_book_id";
static const NSString *kAvailableState = @"available";

static const NSString *kAvailableNO = @"更改为随时可借";
static const NSString *kAvailableYES = @"更改为不可借";
static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";
static const NSString *kExistYES = @"书库已有";
static const NSString *kExistNO = @"书库没有";
static const NSString *kAddToMyBook = @"添加至书库";
static const NSString *kDeleteFromMyBook = @"从书库移除";


@implementation BookDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (//implicitly change _book.availability if neccessary
        [[BookStore sharedStore] storeHasBook:_book]) {
        _existenceStatus = YES;
    } else {
        _existenceStatus = NO;
    }
    
    [self setLabelWithBookExistence:_existenceStatus];

    _availabilityStatus = _book.availability;
    [self setLabelTextWithBookAvailability:_availabilityStatus];
    
    //set the view components.
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
}

- (IBAction)changeAvailability:(id)sender {
    _isChangingAvailability = YES;
    _isAdding = NO;
    _isDeleting = NO;

    if (_availabilityStatus == YES) {
        // change availabilityStatus both in store and server & change labels accordingly
    } else if (_availabilityStatus == NO) {
        // change availabilityStatus both in store and server & change labels accordingly
    }
    
    [self putChangeStatusRequestWithBookId:_book.bookId available:(!_availabilityStatus) userId:[self currentUserId] accessToken:[self currentUserAccessToken]];
}

- (IBAction)changeExistence:(id)sender {
    _isChangingAvailability = NO;
    
    if (_existenceStatus == YES) {
        _isDeleting = YES;
        _isAdding = NO;
        
        //Delete book from store & change labels and statuses accordingly
        [self putDeleteBookRequestWithBookId:_book.bookId
                                      userId:[self currentUserId]
                                  accessToke:[self currentUserAccessToken]];
        [[BookStore sharedStore] deleteBookFromStore:_book];
    } else if (_existenceStatus == NO) {
        _isDeleting = NO;
        _isAdding = YES;
        
        //Add book to store & change labels and statuses accordingly
        [self postAddBookRequestWithBookId:_book.bookId available:NO
                                    userId:[self currentUserId]
                                accessToke:[self currentUserAccessToken]];
        [[BookStore sharedStore] addBookToStore:_book];
    }
    [[UserStore sharedStore] refreshBookCountForUser:[self currentUserId]];
}

#pragma mark -- current user info
- (NSString *)currentUserId
{
    User *currentUser = [UserManager currentUser];
    return currentUser.userId;
}
- (NSString *)currentUserAccessToken
{
    User *currentUser = [UserManager currentUser];
    return currentUser.accessToken;
}

#pragma mark -- change existence and availability labels
- (void)setLabelWithBookExistence:(BOOL)existence
{
    if (existence == YES) {
        _existenceLabel.text = (NSString *)kExistYES;
        _changeExistenceButton.titleLabel.text = (NSString *)kDeleteFromMyBook;
    } else {
        _existenceLabel.text = (NSString *)kExistNO;
        _changeExistenceButton.titleLabel.text = (NSString *)kAddToMyBook;
    }
}
- (void)setLabelTextWithBookAvailability:(BOOL)availability
{
    _changeAvailabilityButton.titleLabel.text = (availability == YES)? (NSString *)kAvailableYES : (NSString *)kAvailableNO;
    _availabilityLabel.text = (availability == YES)? (NSString *)kStatusYES : (NSString *)kStatusNO;
}

#pragma mark -- NSURLConnection builer

// for adding book to store
- (void)postAddBookRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    // initialize NSURLRequest
    NSURL *postURL = [NSURL URLWithString:[kAddBookURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    // configure requestBody
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    
    // configure requestMethod & header
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    // build NSURLConnection with request
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

// for deleting book from store
- (void)putDeleteBookRequestWithBookId:(NSString *)bookId
 userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    // initialize NSURLRequest
    NSURL *postURL = [NSURL URLWithString:[kDeleteBookURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    // configure requestBody
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    
    // configure requestMethod & header
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    // build NSURLConnection with request
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

// for changing book availabiltiy
- (void)putChangeStatusRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    // initialize NSURLRequest
    NSURL *postURL = [NSURL URLWithString:[kChangeBookStatusURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    // configure requestBody
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    
    // configure requestMethod & header
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    // build NSURLConnection with request
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        if (_isChangingAvailability) {
            [AlertHelper showAlertWithMessage:@"修改图书状态失败" target:self];
        } else if (_isAdding) {
            [AlertHelper showAlertWithMessage:@"添加图书失败" target:self];
        } else if (_isDeleting) {
            [AlertHelper showAlertWithMessage:@"删除图书失败" target:self];
        }
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", userObject);
    if (_isChangingAvailability) {
        
        //change _availabilityStatus
        _availabilityStatus = [[userObject valueForKey:(NSString *)kAvailableState] boolValue];
        
        //async label
        [self setLabelTextWithBookAvailability:_availabilityStatus];
        
        //async store
        _book.availability = _availabilityStatus;
        [[BookStore sharedStore] changeStoredBookStatusWithBook:_book];
        
        [AlertHelper showAlertWithMessage:@"修改图书状态成功" target:self];
    } else if (_isAdding || _isDeleting) {
        
        //change _existenceStatus
        _existenceStatus = !_existenceStatus;
        
        //async label
        // ......
        
        //async store
        // ......
        
        if (_isAdding) {
            [AlertHelper showAlertWithMessage:@"添加图书成功" target:self];
        } else if (_isDeleting) {
            [AlertHelper showAlertWithMessage:@"删除图书成功" target:self];
        }
    }
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
