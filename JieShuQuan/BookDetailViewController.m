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
#import "UserStore.h"
#import "Book.h"
#import "AlertHelper.h"
#import "ServerHeaders.h"
#import "UserManager.h"
#import "User.h"
#import "MyBooksTableViewController.h"
#import "SearchTableViewController.h"

static const NSString *kBookId = @"douban_book_id";
static const NSString *kAvailableState = @"available";

static const NSString *kAvailableNO = @"更改为随时可借";
static const NSString *kAvailableYES = @"更改为不可借";
static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";



@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //find the previous controller and determine which components not to display.
    NSArray *navStackControllers = [self.navigationController viewControllers];
    id prevController = [navStackControllers objectAtIndex:([navStackControllers count]-2)];
    if ([prevController class] == [MyBooksTableViewController class]) {
        [self.navigationItem setRightBarButtonItem:nil];
        _isChangingStatus = YES;
    } else if ([prevController class] == [SearchTableViewController class]) {
        [_changeAvailabilityButton setHidden:YES];
        [_availabilityLabel setHidden:YES];
        _isChangingStatus = NO;
    }
    //set the view components.
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
    _availabilityStatus = _book.availability;
    [self setLabelTextWithBookAvailability:_availabilityStatus];
}

- (void)setLabelTextWithBookAvailability:(BOOL)availability
{
    _changeAvailabilityButton.titleLabel.text = (availability == YES)? (NSString *)kAvailableYES : (NSString *)kAvailableNO;
    _availabilityLabel.text = (availability == YES)? (NSString *)kStatusYES : (NSString *)kStatusNO;
}

- (IBAction)addBook:(id)sender {
    User *currentUser = [UserManager currentUser];
    NSString *currentUserId = currentUser.userId;
                         
    if ([[BookStore sharedStore] storeHasBook:_book]) {
        [AlertHelper showAlertWithMessage:@"我的书库已有此书" target:self];
    } else {
        [AlertHelper showAlertWithMessage:@"已添加至我的书库" target:self];
        [self postAddBookRequestWithBookId:_book.bookId available:NO
                             userId:currentUserId
                         accessToke:[currentUser accessToken]];
        [[BookStore sharedStore] addBookToStore:_book];
        [[UserStore sharedStore] refreshBookCountForUser:currentUserId];
    }
}

- (IBAction)changeAvailability:(id)sender {
    User *currentUser = [UserManager currentUser];
    NSString *currentUserId = currentUser.userId;
    
    [self putChangeStatusRequestWithBookId:_book.bookId available:(!_availabilityStatus) userId:currentUserId accessToken:[currentUser accessToken]];
}

- (void)putChangeStatusRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
                              userId, @"user_id",
                              accessToken, @"access_token", nil];
    NSURL *postURL = [NSURL URLWithString:[kChangeBookStatusURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

}

- (void)postAddBookRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bookId, kBookId,
                              [NSNumber numberWithInteger:availabilityState], kAvailableState,
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
    if ([(NSHTTPURLResponse *)response statusCode] != 200) {
        if (_isChangingStatus) {
            [AlertHelper showAlertWithMessage:@"修改图书状态失败" target:self];
        } else [AlertHelper showAlertWithMessage:@"添加图书失败" target:self];
        return;
    }
    [self.navigationItem setRightBarButtonItem:nil];
    [_changeAvailabilityButton setHidden:NO];
    [_availabilityLabel setHidden:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", userObject);
    if (_isChangingStatus) {
        _availabilityStatus = [[userObject valueForKey:(NSString *)kAvailableState] boolValue];
        _book.availability = _availabilityStatus;
        [[BookStore sharedStore] changeStoredBookStatusWithBook:_book];
        [self setLabelTextWithBookAvailability:_availabilityStatus];
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
