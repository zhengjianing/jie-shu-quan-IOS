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
#import "RequestBuilder.h"
#import "FriendsHasBookTableViewController.h"


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
    [self initActivityIndicator];
}

- (void)initActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initBookDetailView];

    if ([self alreadyHasBook]) {
        _existenceStatus = YES;
    } else {
        _existenceStatus = NO;
        [self disableAvailabilityArea];
    }
    
    // set existence & availability status
    [self setLabelWithBookExistence:_existenceStatus];
    [self setLabelTextWithBookAvailability:_book.availability];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBookDetailView
{
    //set the view components.
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = _book.authors;
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
}

- (BOOL)alreadyHasBook
{
    // do this to save unnecessary coreData-searching & comparing when the prevController is MyBooksTableViewController
    NSArray *navStack = [self.navigationController viewControllers];
    id prevController = [navStack objectAtIndex:([navStack count]-2)];
    return [prevController isKindOfClass:[MyBooksTableViewController class]]
    //implicitly change _book.availability if neccessary
    || [[BookStore sharedStore] storeHasBook:_book];
}

#pragma mark - change existence and availability labels

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

- (void)disableAvailabilityArea
{
    [_changeAvailabilityButton setEnabled:NO];
    [_changeAvailabilityButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_availabilityLabel setTextColor:[UIColor grayColor]];
}

- (void)enableAvailabilityArea
{
    [_changeAvailabilityButton setEnabled:YES];
    [_changeAvailabilityButton setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    [_availabilityLabel setTextColor:[UIColor blackColor]];
}

#pragma mark - changed existence and availability

- (IBAction)changeAvailability:(id)sender {
    availabilitySheet = [ActionSheetHelper actionSheetWithTitle:@"确认修改状态吗？" delegate:self];
    [availabilitySheet showInView:self.view];
}

- (IBAction)changeExistence:(id)sender {
    if (_existenceStatus == YES) {
        deleteSheet = [ActionSheetHelper actionSheetWithTitle:@"确认删除吗？" delegate:self];
        [deleteSheet showInView:self.view];
        return;
    }
    
    if (_existenceStatus == NO) {
        addSheet = [ActionSheetHelper actionSheetWithTitle:@"确认添加吗？" delegate:self];
        [addSheet showInView:self.view];
        return;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }
    
    [_activityIndicator startAnimating];
    
    NSString *user_id = [[UserManager currentUser] userId];
    NSString *access_token = [[UserManager currentUser] accessToken];
    if (actionSheet == deleteSheet) {
        [self putDeleteBookRequestWithBookId:_book.bookId userId:user_id accessToke:access_token];
        return;
    }
    
    if (actionSheet == availabilitySheet) {
        [self putChangeStatusRequestWithBookId:_book.bookId available:(!_book.availability) userId:user_id accessToken:access_token];
        return;
    }
    
    if (actionSheet == addSheet) {
        [self postAddBookRequestWithBook:_book available:NO userId:user_id accessToke:access_token];
        return;
    }
}

#pragma mark - configure NSURLConnections

- (void)postAddBookRequestWithBook:(Book *)book available:(BOOL)available userId:(NSString *)userId accessToke:(NSString *)accessToke
{
    NSMutableURLRequest *addBookRequest = [RequestBuilder buildAddBookRequestWithBook:book available:NO userId:userId accessToke:accessToke];
    
    [NSURLConnection sendAsynchronousRequest:addBookRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"添加图书失败" target:self];
            return;
        }
        
        _existenceStatus = !_existenceStatus;
        
        [[BookStore sharedStore] addBookToStore:_book];
        [[UserStore sharedStore] increseBookCountForUser:[[UserManager currentUser] userId]];
       
        [self enableAvailabilityArea];
        [self setLabelWithBookExistence:YES];
    }];
}

- (void)putDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSMutableURLRequest *deleteBookRequest = [RequestBuilder buildDeleteBookRequestWithBookId:bookId userId:userId accessToke:accessToken];
    [NSURLConnection sendAsynchronousRequest:deleteBookRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"删除图书失败" target:self];
            return;
        }
        
        _existenceStatus = !_existenceStatus;

        [[BookStore sharedStore] deleteBookFromStore:_book];
        [[UserStore sharedStore] decreseBookCountForUser:[[UserManager currentUser] userId]];
        
        [self disableAvailabilityArea];
        [self setLabelWithBookExistence:NO];
        [self setLabelTextWithBookAvailability:NO];
    }];
}

- (void)putChangeStatusRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    NSMutableURLRequest *changeAvailabilityRequest = [RequestBuilder buildChangeBookAvailabilityRequestWithBookId:bookId available:availabilityState userId:userId accessToken:accessToken];
    [NSURLConnection sendAsynchronousRequest:changeAvailabilityRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"修改图书状态失败" target:self];
            return;
        }
        
        _book.availability = !_book.availability;
        [[BookStore sharedStore] changeStoredBookStatusWithBook:_book];
        
        [self setLabelTextWithBookAvailability:_book.availability];
    }];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([indexPath section] == 2) {
//        FriendsHasBookTableViewController *friendsHasBookTableViewController = [[FriendsHasBookTableViewController alloc] init];
//        [self.navigationController pushViewController:friendsHasBookTableViewController animated:YES];
//    }
//}

@end
