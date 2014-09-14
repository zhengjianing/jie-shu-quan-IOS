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
#import "MyBooksTableViewController.h"
#import "SearchTableViewController.h"
#import "ActionSheetHelper.h"

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

@interface BookDetailTableViewController ()
{
    UIActionSheet *availabilitySheet;
    UIActionSheet *deleteSheet;
    UIActionSheet *addSheet;
}

@end

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
    
    // do this to save unnecessary coreData-searching & comparing when the prevController is MyBooksTableViewController
    NSArray *navStack = [self.navigationController viewControllers];
    id prevController = [navStack objectAtIndex:([navStack count]-2)];
    if ([prevController isKindOfClass:[MyBooksTableViewController class]]
        //implicitly change _book.availability if neccessary
        ||[[BookStore sharedStore] storeHasBook:_book]) {
        _existenceStatus = YES;
    } else
        _existenceStatus = NO;
    
    _availabilityStatus = _book.availability;
    
    // set existence & availability status
    [self setLabelWithBookExistence:_existenceStatus];
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
        [_changeExistenceButton setTitle:(NSString *)kDeleteFromMyBook forState:UIControlStateNormal];
    } else {
        _existenceLabel.text = (NSString *)kExistNO;
        [_changeExistenceButton setTitle:(NSString *)kAddToMyBook forState:UIControlStateNormal];
    }
}
- (void)setLabelTextWithBookAvailability:(BOOL)availability
{
    if (availability == YES) {
        _availabilityLabel.text = (NSString *)kStatusYES;
        [_changeAvailabilityButton setTitle:(NSString *)kAvailableYES forState:UIControlStateNormal];
    } else {
        _availabilityLabel.text = (NSString *)kStatusNO;
        [_changeAvailabilityButton setTitle:(NSString *)kAvailableNO forState:UIControlStateNormal];
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
    
    availabilitySheet = [ActionSheetHelper actionSheetWithTitle:@"确认修改状态吗？" delegate:self];
    [availabilitySheet showInView:self.view];
}
- (IBAction)changeExistence:(id)sender {
    _isChangingAvailability = NO;
    
    if (_existenceStatus == YES) {
        _isDeleting = YES;
        _isAdding = NO;
        
        deleteSheet = [ActionSheetHelper actionSheetWithTitle:@"确认删除吗？" delegate:self];
        [deleteSheet showInView:self.view];
    } else if (_existenceStatus == NO) {
        _isDeleting = NO;
        _isAdding = YES;
        
        addSheet = [ActionSheetHelper actionSheetWithTitle:@"确认添加吗？" delegate:self];
        [addSheet showInView:self.view];
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_activityIndicator startAnimating];
        
        if (actionSheet == deleteSheet) {
            //post request to delete book from server side
            [self putDeleteBookRequestWithBookId:_book.bookId
                                          userId:[self currentUserId]
                                      accessToke:[self currentUserAccessToken]];
        } else if (actionSheet == availabilitySheet) {
            // launch NSURLConnection to change availability
            [self putChangeStatusRequestWithBookId:_book.bookId available:(!_availabilityStatus) userId:[self currentUserId] accessToken:[self currentUserAccessToken]];
        } else if (actionSheet == addSheet) {
            //post request to add book to server side
            [self postAddBookRequestWithBookId:_book.bookId available:NO
                                        userId:[self currentUserId]
                                    accessToke:[self currentUserAccessToken]];
        }
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
        
        id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@", userObject);
        if (_isChangingAvailability) {
            _availabilityStatus = !_availabilityStatus;
            
            //async store
            _book.availability = _availabilityStatus;
            [[BookStore sharedStore] changeStoredBookStatusWithBook:_book];
        } else if (_isAdding || _isDeleting) {
            _existenceStatus = !_existenceStatus;
            if (_isAdding) {
                //async store
                [[BookStore sharedStore] addBookToStore:_book];
                [[UserStore sharedStore] increseBookCountForUser:[self currentUserId]];
            } else {
                // if deleted, must set _availabilityStatus to NO !!!
                _availabilityStatus = NO;
                
                //async store
                [[BookStore sharedStore] deleteBookFromStore:_book];
                [[UserStore sharedStore] decreseBookCountForUser:[self currentUserId]];
            }
        }
        [[BookStore sharedStore] refreshStoredBooks];
        [self setLabelWithBookExistence:_existenceStatus];
        [self setLabelTextWithBookAvailability:_availabilityStatus];
        [_activityIndicator stopAnimating];
        [self.tableView reloadData];
        
    }];
}

@end
