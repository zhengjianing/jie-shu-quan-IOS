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
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (//implicitly change _book.availability if neccessary
        [[BookStore sharedStore] storeHasBook:_book]) {
        _existenceStatus = YES;
    } else
        _existenceStatus = NO;
    
    // set existence status
    [self setLabelWithBookExistence:_existenceStatus];
    
    // set availability status
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
    if (availability == YES) {
        _changeAvailabilityButton.titleLabel.text = (NSString *)kAvailableYES;
        _availabilityLabel.text = (NSString *)kStatusYES;
    } else {
        _changeAvailabilityButton.titleLabel.text = (NSString *)kAvailableNO;
        _availabilityLabel.text = (NSString *)kStatusNO;
    }
}

#pragma mark -- changed existence and availability
- (IBAction)changeAvailability:(id)sender {
    if (_existenceStatus == NO) {
        [AlertHelper showAlertWithMessage:@"当前图书不存在，\n请添加后再设置状态" target:self];
        return;
    }
    _isChangingAvailability = YES;
    _isAdding = NO;
    _isDeleting = NO;
    
    [_activityIndicator startAnimating];
    
    // launch NSURLConnection to change availability
    [self putChangeStatusRequestWithBookId:_book.bookId available:(!_availabilityStatus) userId:[self currentUserId] accessToken:[self currentUserAccessToken]];
}
- (IBAction)changeExistence:(id)sender {
    _isChangingAvailability = NO;
    
    if (_existenceStatus == YES) {
        _isDeleting = YES;
        _isAdding = NO;
        
        [_activityIndicator startAnimating];
        
        //post request to delete book from server side
        [self putDeleteBookRequestWithBookId:_book.bookId
                                      userId:[self currentUserId]
                                  accessToke:[self currentUserAccessToken]];
    } else if (_existenceStatus == NO) {
        _isDeleting = NO;
        _isAdding = YES;
        
        [_activityIndicator startAnimating];
        
        //post request to add book to server side
        [self postAddBookRequestWithBookId:_book.bookId available:NO
                                    userId:[self currentUserId]
                                accessToke:[self currentUserAccessToken]];
    }
}

#pragma mark -- current user info
- (NSString *)currentUserId {
    return [[UserManager currentUser] userId];
}
- (NSString *)currentUserAccessToken {
    return [[UserManager currentUser] accessToken];
}

#pragma mark -- configure NSURLConnections
// launch NSRULConnection to add book to store
- (void)postAddBookRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    [self launchConnectionWithRequestURLString:kAddBookURL bodyDictionary:bodyDict HTTPMethod:@"POST"];
}
// launch NSRULConnection to delete book from store
- (void)putDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    [self launchConnectionWithRequestURLString:kDeleteBookURL bodyDictionary:bodyDict HTTPMethod:@"PUT"];
}
// launch NSRULConnection to change book availabiltiy in store
- (void)putChangeStatusRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    [self launchConnectionWithRequestURLString:kChangeBookStatusURL bodyDictionary:bodyDict HTTPMethod:@"PUT"];
}

// NSURLConnection builder
- (void)launchConnectionWithRequestURLString:(NSString *)requestString bodyDictionary:(NSDictionary *)bodyDictionary HTTPMethod:(NSString *)HTTPMethod
{
    // initialize NSURLRequest
    NSURL *postURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    // configure requestBody
    id object = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    
    // configure requestMethod & header
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:HTTPMethod];
    
    // build NSURLConnection with request
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        [_activityIndicator stopAnimating];

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
        
        [_activityIndicator stopAnimating];
        [AlertHelper showAlertWithMessage:@"修改图书状态成功" target:self];
    } else if (_isAdding || _isDeleting) {
        if (_isAdding) {
            _existenceStatus = YES;
            [self setLabelWithBookExistence:_existenceStatus];
            
            //async store
            [[BookStore sharedStore] addBookToStore:_book];
            [_activityIndicator stopAnimating];
            [AlertHelper showAlertWithMessage:@"添加图书成功" target:self];
        } else if (_isDeleting) {
            _existenceStatus = NO;
            [self setLabelWithBookExistence:_existenceStatus];
            
            // if deleted, must set _availabilityStatus to NO !!!
            _availabilityStatus = NO;
            
            //async _availabilityStatus label
            [self setLabelTextWithBookAvailability:_availabilityStatus];
            
            //async store
            [[BookStore sharedStore] deleteBookFromStore:_book];
            [_activityIndicator stopAnimating];
            [AlertHelper showAlertWithMessage:@"删除图书成功" target:self];
        }
        [[UserStore sharedStore] refreshBookCountForUser:[self currentUserId]];
    }
}

@end
