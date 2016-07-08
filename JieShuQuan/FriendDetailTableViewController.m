//
//  FriendDetailTableViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/11/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "FriendDetailTableViewController.h"
#import "FriendBookTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Friend.h"
#import "Book.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "User.h"
#import "DataConverter.h"
#import "MailManager.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"
#import "AvatarManager.h"
#import "CustomAlert.h"
#import <UMMobClick/MobClick.h>
#import "IconHelper.h"
#import "CustomColor.h"
#import "BorrowService.h"
#import "ActionSheetHelper.h"
@interface FriendDetailTableViewController ()
{
    UIActionSheet *borrowActionSheet;
}
@end

@implementation FriendDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *name = [_currentFriend.friendName isEqualToString:@""] ? @"Ta" : _currentFriend.friendName;
    self.navigationItem.title = [name stringByAppendingString:@"的书"];
    [self setTableFooterView];
    [self configureFriendInfoView];
    [self.tableView addSubview:self.messageLabel];
    _messageLabel.hidden = YES;
    _books = [[NSMutableArray alloc] init];
    _isFromMyFriends = YES;
    [self.tableView reloadData];
    [self loadBooksForFriend];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFromMyFriends) {
        [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    }
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"friendDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"friendDetailPage"];
    [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
}

- (UILabel *)messageLabel
{
    if (_messageLabel != nil) {
        return _messageLabel;
    }
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"该同事的书库暂时是空的"];
    return _messageLabel;
}

- (void)setTableFooterView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)configureFriendInfoView
{
    [AvatarManager setAvatarStyleForImageView:_friendAvatarImageView];
    NSURL *avatarURL = [NSURL URLWithString:_currentFriend.avatarURLString];
    [_friendAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    
    _friendNameLabel.text = [_currentFriend.friendName isEqualToString:@""] ? _currentFriend.friendEmail : _currentFriend.friendName;
    _friendBookCountLabel.text = _currentFriend.bookCount;
    _friendLocationLabel.text = _currentFriend.friendLocation;
}

- (void)loadBooksForFriend
{
    [self fetchBooksForFriendFromServer];
}

#pragma mark - fetch books for friend from server

- (void)fetchBooksForFriendFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:_currentFriend.friendId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"请求失败"];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_books removeAllObjects];
            
            NSArray *booksArray = [responseObject valueForKey:@"books"];
            
            if (booksArray.count == 0) {
                _messageLabel.hidden = NO;
                return;
            }
            
            _messageLabel.hidden = YES;
            for (id bookItem in booksArray) {
                Book *book = [DataConverter bookFromServerBookObject:bookItem];
                [_books addObject:book];
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendBookIdentifier" forIndexPath:indexPath];
       
    Book *book = [_books objectAtIndex:indexPath.row];
    
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imageHref]];
    cell.bookNameLabel.text = book.name;
    cell.authorsLabel.text = book.authors;
    cell.bookId = book.bookId;
    
    [cell.mailImageView setImage:[IconHelper emailIcon]];

    if (book.availability == NO) {
        cell.availabilityLabel.hidden = NO;
        cell.borrowButton.hidden = YES;
        cell.mailImageView.hidden = YES;
    } else {
        cell.availabilityLabel.hidden = YES;
        cell.borrowButton.layer.borderColor = [CustomColor mainRedColor].CGColor;
        cell.borrowButton.layer.cornerRadius = 5.0;
        cell.borrowButton.layer.borderWidth = 0.5;
        cell.borrowButton.hidden = NO;
        cell.mailImageView.hidden = NO;
    }
    
    return cell;
}

#pragma mark - Borrow from friend

- (IBAction)borrowFromFriend:(id)sender {
    [MobClick event:@"borrowFromFriendButtonPressed"];

    FriendBookTableViewCell *selectedCell;
    id superView1 = [sender superview];
    if ([superView1 isKindOfClass:[FriendBookTableViewCell class]]) {
        selectedCell = (FriendBookTableViewCell *)superView1;
    } else {
        id superView2 = [superView1 superview];
        if ([superView2 isKindOfClass:[FriendBookTableViewCell class]]) {
            selectedCell = (FriendBookTableViewCell *)superView2;
        } else {
            id superView3 = [superView2 superview];
            if ([superView3 isKindOfClass:[FriendBookTableViewCell class]]) {
                selectedCell = (FriendBookTableViewCell *)superView3;
            } else return;
        }
    }

    NSString *bookName = selectedCell.bookNameLabel.text;
    _selectedBookId = selectedCell.bookId;
    
//    发邮件
//    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//    if (mailClass != nil && [mailClass canSendMail]) {
//        [MailManager displayComposerSheetToName:_currentFriend.friendName toEmailAddress:_currentFriend.friendEmail forBook:bookName delegate:self];
//    } else {
//        [MailManager launchMailToName:_currentFriend.friendName toEmailAddress:_currentFriend.friendEmail forBook:bookName];
//    }
    
    
//    发送借书申请
    borrowActionSheet = [ActionSheetHelper actionSheetWithTitle:@"将向他发送借书通知" delegate:self];
    [borrowActionSheet showInView:self.view];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSMutableURLRequest *collectBorrowingInfoRequest = [RequestBuilder buildPostCollectBookBorrowingInfoRequestWithBookId:_selectedBookId borrowerId:[[UserManager currentUser] userId] lenderId:_currentFriend.friendId];
        [NSURLConnection sendAsynchronousRequest:collectBorrowingInfoRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    _isFromMyFriends = NO;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

        BorrowService *borrowService = [[BorrowService alloc] init];
        [borrowService createBorrowRecordWithBookId:_selectedBookId borrowerId:[[UserManager currentUser] userId] lenderId:_currentFriend.friendId success:^{
            {
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                [[CustomAlert sharedAlert] showAlertWithMessage:@"借书申请发送成功"];
            }
        } failure:^{
            {
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                [[CustomAlert sharedAlert] showAlertWithMessage:@"借书申请发送失败"];
            }
        }];
    }
}

@end
