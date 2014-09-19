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
#import "AlertHelper.h"
#import "DataConverter.h"
#import "MailManager.h"

@interface FriendDetailTableViewController ()

@end

@implementation FriendDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSelfWhenLoggingOut) name:@"popSubViewControllers" object:nil];
    
    [self removeUnneccessaryCells];
    [self configureFriendInfoView];
    [self initActivityIndicator];
    
    [self loadBooksForFriend];
    [self.tableView reloadData];
}

- (void)popSelfWhenLoggingOut
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)removeUnneccessaryCells
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)configureFriendInfoView
{
    _friendNameLabel.text = _friend.friendName;
    _friendBookCountLabel.text = _friend.bookCount;
    _friendEmailLabel.text = _friend.friendEmail;
}

- (void)initActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
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
            [AlertHelper showAlertWithMessage:@"更新失败" withAutoDismiss:YES target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_books removeAllObjects];
            
            NSArray *booksArray = [responseObject valueForKey:@"books"];
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
        cell.availabilityLabel.text = @"暂时不可借";
        [cell.borrowButton setEnabled:NO];
    } else {
        cell.availabilityLabel.text = @"可借";
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
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            [AlertHelper showAlertWithMessage:@"邮件发送取消，已保存至草稿箱" withAutoDismiss:YES target:self];
            break;
        case MFMailComposeResultSent:
            [AlertHelper showAlertWithMessage:@"邮件发送成功" withAutoDismiss:YES target:self];
            break;
        case MFMailComposeResultFailed:
            [AlertHelper showAlertWithMessage:@"邮件发送失败" withAutoDismiss:YES target:self];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
