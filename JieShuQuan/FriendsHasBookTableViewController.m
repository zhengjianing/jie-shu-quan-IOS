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
#import "AlertHelper.h"
#import "Friend.h"
#import "DataConverter.h"
#import "LoginViewController.h"
#import "MailManager.h"
#import "MessageLabelHelper.h"
#import "CustomActivityIndicator.h"
#import "AvatarManager.h"

@interface FriendsHasBookTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) LoginViewController *loginController;

@end

@implementation FriendsHasBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    [self configureBookInfoView];
    [self setTableFooterView];
    [self.tableView addSubview:self.activityIndicator];
    [self.tableView addSubview:self.messageLabel];
    [self.tableView addSubview:self.preLoginView];

    _loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self showTableView];
}

- (void)showTableView
{
    if ([UserManager isLogin]) {
        _preLoginView.hidden = YES;
        [_activityIndicator startAnimating];
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
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"没有找到拥有此书的同事，请向更多的同事推荐此应用"];
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
        _preLoginView.delegate = self;
    }
    return _preLoginView;
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
}

- (void)loadFriendsWithBook
{
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
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            //没有找到同事
            _messageLabel.hidden = NO;
            return ;
        }

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败，请稍后重试" withAutoDismiss:YES];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_friendsCellObject removeAllObjects];
            
            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            
            if (friendsArray.count == 0) {
                _messageLabel.hidden = NO;
                return;
            }
            
            for (id item in friendsArray) {
                Friend *friend = [DataConverter friendFromServerFriendObject:item];
                NSDictionary *friendCellDict = @{@"friend":friend, @"availability":[item valueForKey:@"available"]};
                [_friendsCellObject addObject:friendCellDict];
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
    return _friendsCellObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendHasBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookDetailCell" forIndexPath:indexPath];
    
    NSDictionary *friendCellObject = [_friendsCellObject objectAtIndex:indexPath.row];
    Friend *friend = friendCellObject[@"friend"];
    NSInteger availability = [friendCellObject[@"availability"] integerValue];
    
    NSURL *avatarURL = [AvatarManager avatarURLForUserId:friend.friendId];
    [cell.friendAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:[AvatarManager defaulFriendAvatar]];
    [AvatarManager setAvatarStyleForImageView:cell.friendAvatarImageView];
    
    cell.friendNameLabel.text = friend.friendName;
    cell.friendEmailLabel.text = friend.friendEmail;
    cell.locationLabel.text = friend.friendLocation;
    cell.friendEmailLabel.hidden = YES;
    cell.friendBookAvailibilityLabel.text = (availability == 0) ? @"暂时不可借" : @"可借";
    
    if (availability ==0) {
        cell.borrowButton.hidden = YES;
        cell.mailImageView.hidden = YES;
    } else {
        cell.borrowButton.layer.cornerRadius = 5.0;
        cell.borrowButton.layer.borderWidth = 0.5;
        cell.borrowButton.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.borrowButton.hidden = NO;
        cell.mailImageView.hidden = NO;
    }

    return cell;
}

#pragma mark - Borrow from friend

- (IBAction)borrowFromFriend:(id)sender {
    FriendHasBookTableViewCell *selectedCell = (FriendHasBookTableViewCell *)[[[sender superview] superview] superview];
    NSString *toName = selectedCell.friendNameLabel.text;
    NSString *toEmailAddress = selectedCell.friendEmailLabel.text;
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
