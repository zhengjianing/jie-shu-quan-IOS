//
//  FriendsHasBookTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/15/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendsHasBookTableViewController.h"
#import "FriendHasBookTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Book.h"
#import "User.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "Friend.h"
#import "DataConverter.h"
#import "LoginViewController.h"
#import "MailManager.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"
#import "AvatarManager.h"
#import "CustomAlert.h"
#import <UMMobClick/MobClick.h>
#import "IconHelper.h"
#import "CustomColor.h"

@interface FriendsHasBookTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) LoginViewController *loginController;

@end

@implementation FriendsHasBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MobClick event:@"friendsHasBookPageViewed"];

    [self configureBookInfoView];
    [self setTableFooterView];
    [self.tableView addSubview:self.messageLabel];
    [self.tableView addSubview:self.preLoginView];

    _loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self showTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"whoHasBookPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"whoHasBookPage"];
    [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
}

- (void)showTableView
{
    if ([UserManager isLogin]) {
        _preLoginView.hidden = YES;
        [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
        _messageLabel.hidden = YES;
        [self loadFriendsWithBook];
        [self.tableView reloadData];
    } else {
        _preLoginView.hidden = NO;
    }
}

- (void)configureBookInfoView
{
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = _book.authors;
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - initializing tableView accessories

- (UILabel *)messageLabel
{
    if (_messageLabel != nil) {
        return _messageLabel;
    }
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"抱歉，没有找到相关同事，请向更多的同事推荐此应用"];
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
        _preLoginView.frame = self.tableView.bounds;
        _preLoginView.delegate = self;
    }
    return _preLoginView;
}

- (void)loadFriendsWithBook
{
    _allFriendsCellObject = [[NSMutableArray alloc] init];
    _localFriendsCellObject = [[NSMutableArray alloc] init];
    _friendsCellObject = [[NSMutableArray alloc] init];

    [self fetchFriendsWithBookFromServer];
}

#pragma mark - PreLoginDelegate

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
}

#pragma mark - fetch friends from server

- (void)fetchFriendsWithBookFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchFriendsRequestForUserId:[[UserManager currentUser] userId] bookId:_book.bookId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            //没有找到同事
            _messageLabel.hidden = NO;
            return ;
        }

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"请求失败"];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_allFriendsCellObject removeAllObjects];
            
            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            
            if (friendsArray.count == 0) {
                _messageLabel.hidden = NO;
                return;
            }
            
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                NSDictionary *friendCellDict = @{@"friend":friend, @"availability":[item valueForKey:@"available"]};
                [_allFriendsCellObject addObject:friendCellDict];
            }
            
            for (NSMutableDictionary *friendObject in _allFriendsCellObject) {
                if (![[friendObject[@"friend"] friendLocation] isEqualToString:@""] && [[friendObject[@"friend"] friendLocation] isEqualToString:[[UserManager currentUser] location]]) {
                    [_localFriendsCellObject addObject:friendObject];
                }
            }

            [self showTableViewWithCorrectData];
        }
    }];
}

- (void)showTableViewWithCorrectData
{
    _friendsCellObject = [self friendsForSelectedSegmentIndex:_segmentControl.selectedSegmentIndex];
    if (_friendsCellObject.count > 0) {
        _messageLabel.hidden = YES;
    } else {
        _messageLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsCellObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendHasBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookDetailCell" forIndexPath:indexPath];
    
    NSDictionary *friendCellObject = [_friendsCellObject objectAtIndex:indexPath.row];
    Friend *friend = friendCellObject[@"friend"];
    NSInteger availability = [friendCellObject[@"availability"] integerValue];
        
    NSURL *avatarURL = [NSURL URLWithString:friend.avatarURLString];
    [cell.friendAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    [AvatarManager setAvatarStyleForImageView:cell.friendAvatarImageView];
    
    cell.friendId = friend.friendId;
    cell.friendNameLabel.text = [friend.friendName isEqualToString:@""] ? friend.friendEmail : friend.friendName;
    cell.locationLabel.text = friend.friendLocation;

    // always hide email label, only used when send email, will get email address from the label text
    cell.friendEmail = friend.friendEmail;
    
    [cell.mailImageView setImage:[IconHelper emailIcon]];
    
    if (availability == 0) {
        cell.borrowButton.hidden = YES;
        cell.mailImageView.hidden = YES;
        cell.friendBookAvailibilityLabel.hidden = NO;
    } else {
        cell.borrowButton.layer.cornerRadius = 5.0;
        cell.borrowButton.layer.borderWidth = 0.5;
        cell.borrowButton.layer.borderColor = [CustomColor mainRedColor].CGColor;
        cell.borrowButton.hidden = NO;
        cell.mailImageView.hidden = NO;
        cell.friendBookAvailibilityLabel.hidden = YES;
    }

    return cell;
}

#pragma mark - Borrow from friend

- (IBAction)borrowFromFriend:(id)sender {
    [MobClick event:@"borrowFromFriendButtonPressed"];

    FriendHasBookTableViewCell *selectedCell;
    id superView1 = [sender superview];
    if ([superView1 isKindOfClass:[FriendHasBookTableViewCell class]]) {
        selectedCell = (FriendHasBookTableViewCell *)superView1;
    } else {
        id superView2 = [superView1 superview];
        if ([superView2 isKindOfClass:[FriendHasBookTableViewCell class]]) {
            selectedCell = (FriendHasBookTableViewCell *)superView2;
        } else {
            id superView3 = [superView2 superview];
            if ([superView3 isKindOfClass:[FriendHasBookTableViewCell class]]) {
                selectedCell = (FriendHasBookTableViewCell *)superView3;
            } else return;
        }
    }

    _selectedFriendId = selectedCell.friendId;
    NSString *toName = selectedCell.friendNameLabel.text;
    NSString *toEmailAddress = selectedCell.friendEmail;
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil && [mailClass canSendMail]) {
        [MailManager displayComposerSheetToName:toName toEmailAddress:toEmailAddress forBook:_book.name delegate:self];
    } else {
        [MailManager launchMailToName:toName toEmailAddress:toEmailAddress forBook:_book.name];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSMutableURLRequest *collectBorrowingInfoRequest = [RequestBuilder buildPostCollectBookBorrowingInfoRequestWithBookId:_book.bookId borrowerId:[[UserManager currentUser] userId] lenderId:_selectedFriendId];
        [NSURLConnection sendAsynchronousRequest:collectBorrowingInfoRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - segment control

- (IBAction)changeSegmentControl:(id)sender {
    [MobClick event:@"filterFriendsSegmentControlChanged"];

    [self showTableViewWithCorrectData];
}

- (NSMutableArray *)friendsForSelectedSegmentIndex:(NSInteger)index
{
    return (index == 0) ? [_allFriendsCellObject mutableCopy] : [_localFriendsCellObject mutableCopy];
}

@end
