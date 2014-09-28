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

@interface FriendDetailTableViewController ()

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@end

@implementation FriendDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    [self setTableFooterView];
    [self configureFriendInfoView];
    [self.tableView addSubview:self.messageLabel];
    _messageLabel.hidden = YES;
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];
    [_activityIndicator startAnimating];
    
    [self loadBooksForFriend];
    [self.tableView reloadData];
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
    NSURL *avatarURL = [AvatarManager avatarURLForUserId:_friend.friendId];
    [_friendAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    
    _friendNameLabel.text = _friend.friendName;
    _friendBookCountLabel.text = _friend.bookCount;
    _friendLocationLabel.text = _friend.friendLocation;
}

- (void)loadBooksForFriend
{
    _books = [[NSMutableArray alloc] init];
    [self fetchBooksForFriendFromServer];
}

#pragma mark - fetch books for friend from server

- (void)fetchBooksForFriendFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchBooksRequestForUserId:_friend.friendId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"更新失败"];
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

    if (book.availability == NO) {
        cell.availabilityLabel.hidden = NO;
        cell.borrowButton.hidden = YES;
        cell.mailImageView.hidden = YES;
    } else {
        cell.availabilityLabel.hidden = YES;
        cell.borrowButton.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.borrowButton.layer.cornerRadius = 5.0;
        cell.borrowButton.layer.borderWidth = 0.5;
        cell.borrowButton.hidden = NO;
        cell.mailImageView.hidden = NO;
    }
    
    return cell;
}

#pragma mark - Borrow from friend

- (IBAction)borrowFromFriend:(id)sender {
    FriendBookTableViewCell *selectedCell = (FriendBookTableViewCell *)[[[sender superview] superview] superview];
    NSString *bookName = selectedCell.bookNameLabel.text;
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil && [mailClass canSendMail]) {
        [MailManager displayComposerSheetToName:_friend.friendName toEmailAddress:_friend.friendEmail forBook:bookName delegate:self];
    } else {
        [MailManager launchMailToName:_friend.friendName toEmailAddress:_friend.friendEmail forBook:bookName];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
