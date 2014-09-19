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

@interface FriendsHasBookTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) UITableView *myFriendsTableView;

@end

@implementation FriendsHasBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSelfWhenLoggingOut) name:@"popSubViewControllers" object:nil];

    [self initActivityIndicator];
    [self configureBookInfoView];
    [self removeUnneccessaryCells];
    
    _myFriendsTableView = self.tableView;
    _loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self showCorrectView];
}

- (void)showCorrectView
{
    if ([UserManager isLogin]) {
        [self showTableView];
    } else {
        [self showPreLoginView];
    }
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

- (void)initActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 170, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)loadFriendsWithBook
{
    _friendsCellObject = [[NSMutableArray alloc] init];
    [self fetchFriendsWithBookFromServer];
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

- (void)showTableView
{
    self.view = _myFriendsTableView;
    [self loadFriendsWithBook];
    [self.tableView reloadData];
}

#pragma mark - PreLoginDelegate

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
}

- (void)showPreLoginView
{
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginNib" owner:self options:nil];
    if ([topLevelObjs count] > 0)
    {
        _preLoginView = [topLevelObjs lastObject];
        _preLoginView.delegate = self;
    }
    self.view = _preLoginView;
}

#pragma mark - fetch friends from server

- (void)fetchFriendsWithBookFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildFetchFriendsRequestForUserId:[[UserManager currentUser] userId] bookId:_book.bookId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            [AlertHelper showAlertWithMessage:@"没找到您的同事们，请确认您使用企业邮箱注册" withAutoDismiss:NO target:self];
            return ;
        }

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"更新失败" withAutoDismiss:YES target:self];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_friendsCellObject removeAllObjects];
            
            NSArray *friendsArray = [responseObject valueForKey:@"friends"];
            
            if (friendsArray.count == 0) {
                [AlertHelper showAlertWithMessage:@"没有找到拥有此书的同事，请向更多的同事推荐此应用" withAutoDismiss:NO target:self];
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
    
    cell.friendNameLabel.text = friend.friendName;
    cell.friendEmailLabel.text = friend.friendEmail;
    cell.friendBookAvailibilityLabel.text = (availability == 0) ? @"暂时不可借" : @"可借";
    
    if (availability ==0) {
        [cell.borrowButton setEnabled:NO];
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
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            [AlertHelper showAlertWithMessage:@"邮件发送取消" withAutoDismiss:YES target:self];
            break;
        case MFMailComposeResultSent:
            [AlertHelper showAlertWithMessage:@"邮件保存成功" withAutoDismiss:YES target:self];
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
