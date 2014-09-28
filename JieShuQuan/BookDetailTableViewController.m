//
//  BookDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/13/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookDetailTableViewController.h"
#import "FriendsHasBookTableViewController.h"
#import "BookCommentTableViewController.h"
#import "Book.h"
#import "BookStore.h"
#import "User.h"
#import "UserManager.h"
#import "UserStore.h"
#import "ServerHeaders.h"
#import "MyBooksTableViewController.h"
#import "SearchTableViewController.h"
#import "ActionSheetHelper.h"
#import "RequestBuilder.h"
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"

static const NSString *kAvailableNO = @"更改为随时可借";
static const NSString *kAvailableYES = @"更改为不可借";
static const NSString *kStatusYES = @"可借";
static const NSString *kStatusNO = @"暂时不可借";
static const NSString *kExistYES = @"书库已有";
static const NSString *kExistNO = @"书库没有";
static const NSString *kAddToMyBook = @"添加至书库";
static const NSString *kDeleteFromMyBook = @"从书库移除";

static const NSString *kDefaultLabelText = @"暂无介绍";

static const int fontSize = 13;
static const float LINESPACE = 5;

@interface BookDetailTableViewController ()
{
    UIActionSheet *availabilitySheet;
    UIActionSheet *deleteSheet;
    UIActionSheet *addSheet;
}
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) CustomAlert *alert;

@end

@implementation BookDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];
    _alert = [CustomAlert sharedAlert];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
    (_existenceStatus) ? [self enableAvailabilityArea] : [self disableAvailabilityArea];
    [self.tableView reloadData];
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
    _descriptionLabel.text = ([_book.description isEqualToString:@""]) ? (NSString *)kDefaultLabelText : _book.description;
    _authorInfoLabel.text = ([_book.authorInfo isEqualToString:@""]) ? (NSString *)kDefaultLabelText : _book.authorInfo;

    _changeAvailabilityButton.layer.cornerRadius = 5.0;
    _changeAvailabilityButton.layer.borderWidth = 0.5;
    _changeExistenceButton.layer.cornerRadius = 5.0;
    _changeExistenceButton.layer.borderWidth = 0.5;
    
    UIColor *buttonColor = [UIColor orangeColor];
    _changeExistenceButton.layer.borderColor = buttonColor.CGColor;
    [_changeExistenceButton setTitleColor:buttonColor forState:UIControlStateNormal];
}

- (CGFloat)setLayoutForLabel:(UILabel *)label
{
    label.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
    
    CGSize constrainedSize = CGSizeMake(self.tableView.frame.size.width, MAXFLOAT);
    CGSize labelTextSize = [label.text sizeWithFont:[UIFont systemFontOfSize:fontSize+LINESPACE/2.0] constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByCharWrapping];
    
    return labelTextSize.height + 40;
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
    UIColor *color = [UIColor lightGrayColor];
    [_changeAvailabilityButton setEnabled:NO];
    _changeAvailabilityButton.layer.borderColor = color.CGColor;
    [_changeAvailabilityButton setTitleColor:color forState:UIControlStateDisabled];
}

- (void)enableAvailabilityArea
{
    UIColor *color = [UIColor orangeColor];
    [_changeAvailabilityButton setEnabled:YES];
    _changeAvailabilityButton.layer.borderColor = color.CGColor;
    [_changeAvailabilityButton setTitleColor:color forState:UIControlStateNormal];
}

#pragma mark - changed existence and availability

- (IBAction)changeAvailability:(id)sender {
    availabilitySheet = [ActionSheetHelper actionSheetWithTitle:@"确认修改状态吗？" delegate:self];
    [availabilitySheet showInView:self.view];
}

- (IBAction)changeExistence:(id)sender {
    
    // In case the user hasn't logged in yet
    if (![UserManager isLogin]) {
        [_alert showAlertWithMessage:@"您尚未登录，请先登录"];
        return;
    }
    
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
    if (buttonIndex == 0) {
        [_activityIndicator startSynchAnimating];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_activityIndicator stopSynchAnimating];
        return;
    }
    
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

- (NSData *)dataFromSynchronousRequest:(NSURLRequest *)request
{
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] != 200) {
        if ([request.URL.absoluteString isEqualToString:kAddBookURL]) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"添加图书失败"];
        }
        if ([request.URL.absoluteString isEqualToString:kDeleteBookURL])
        {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"删除图书失败"];
        }
        if ([request.URL.absoluteString isEqualToString:kChangeBookStatusURL])
        {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改图书状态失败"];
        }
    }
    return data;
}

#pragma mark - configure NSURLConnections

- (void)postAddBookRequestWithBook:(Book *)book available:(BOOL)available userId:(NSString *)userId accessToke:(NSString *)accessToke
{
    NSMutableURLRequest *addBookRequest = [RequestBuilder buildAddBookRequestWithBook:book available:NO userId:userId accessToke:accessToke];
    NSData *data = [self dataFromSynchronousRequest:addBookRequest];
    
    [_activityIndicator stopSynchAnimating];
    if (data) {
        _existenceStatus = !_existenceStatus;
        
        [[BookStore sharedStore] addBookToStore:_book];
        [[UserStore sharedStore] increseBookCountForUser:[[UserManager currentUser] userId]];
        
        [self enableAvailabilityArea];
        [self setLabelWithBookExistence:YES];
    }
}

- (void)putDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken
{
    NSMutableURLRequest *deleteBookRequest = [RequestBuilder buildDeleteBookRequestWithBookId:bookId userId:userId accessToke:accessToken];
    NSData *data = [self dataFromSynchronousRequest:deleteBookRequest];
    [_activityIndicator stopSynchAnimating];
    
    if (data) {
        _existenceStatus = !_existenceStatus;
        
        [[BookStore sharedStore] deleteBookFromStore:_book];
        [[UserStore sharedStore] decreseBookCountForUser:[[UserManager currentUser] userId]];
        
        [self setLabelWithBookExistence:NO];
        [self setLabelTextWithBookAvailability:NO];
        [self disableAvailabilityArea];
    }
}

- (void)putChangeStatusRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken
{
    NSMutableURLRequest *changeAvailabilityRequest = [RequestBuilder buildChangeBookAvailabilityRequestWithBookId:bookId available:availabilityState userId:userId accessToken:accessToken];
    NSData *data = [self dataFromSynchronousRequest:changeAvailabilityRequest];
    [_activityIndicator stopSynchAnimating];
    
    if (data) {
        _book.availability = !_book.availability;
        [[BookStore sharedStore] changeStoredBookStatusWithBook:_book];
        
        [self setLabelTextWithBookAvailability:_book.availability];
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 132;
        case 1:
            if (indexPath.row == 1) {
                return 75;
            }
        case 4:
            if (indexPath.row == 1) {
                return [self setLayoutForLabel:_descriptionLabel];
            }
        case 5:
            if (indexPath.row == 1) {
                return [self setLayoutForLabel:_authorInfoLabel];
            }
        default:
            return 40;
    }
    return 40;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setBook:_book];
}

@end
