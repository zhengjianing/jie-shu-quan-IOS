//
//  BookCommentTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-25.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookCommentTableViewController.h"
#import "PreLoginView.h"
#import "BookCommentTableViewCell.h"
#import "LoginViewController.h"
#import "Book.h"
#import "User.h"
#import "UserManager.h"
#import "RequestBuilder.h"
#import "ServerHeaders.h"
#import "AlertHelper.h"
#import "Comment.h"
#import "DataConverter.h"
#import "MessageLabelHelper.h"

@interface BookCommentTableViewController ()

@property (strong, nonatomic) PreLoginView *preLoginView;
@property (strong, nonatomic) LoginViewController *loginController;

@end

@implementation BookCommentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    _CommentCellObject = [[NSMutableArray alloc] init];
    [self configureBookInfoView];
    [self setTableFooterView];
    [self.tableView addSubview:self.messageLabel];
    [self.tableView addSubview:self.activityIndicator];
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
        [self loadAllBookCommentsFromServer];
    } else {
        _preLoginView.hidden = NO;
    }
}

#pragma mark - initializing tableView accessories

- (UILabel *)messageLabel
{
    if (_messageLabel != nil) {
        return _messageLabel;
    }
    _messageLabel = [MessageLabelHelper createMessageLabelWithMessage:@"没有找到此书的评论"];
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

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
}

- (void)loadAllBookCommentsFromServer
{
    NSMutableURLRequest *request = [RequestBuilder buildGetBookCommentsRequestWithBookId:_book.bookId];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_activityIndicator stopAnimating];
        
        if ([(NSHTTPURLResponse *)response statusCode] == 404) {
            //没有找到评论
            _messageLabel.hidden = NO;
            return ;
        }
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"获取评论失败" withAutoDismiss:YES];
            return ;
        }
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            [_CommentCellObject removeAllObjects];
            
            NSArray *commentsArray = [responseObject valueForKey:@"comments"];
            
            if ([commentsArray count] == 0) {
                _messageLabel.hidden = NO;
                return;
            }
            
            for (id object in commentsArray) {
                [_CommentCellObject addObject:[DataConverter commentFromObject:object]];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - PreLoginDelegate

- (void)login
{
    [self.navigationController pushViewController:_loginController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _CommentCellObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCommentCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[BookCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bookCommentCell"];
    }
    
    Comment *comment = [_CommentCellObject objectAtIndex:indexPath.row];
    cell.bookCommentLabel.text = comment.content;
    cell.userNameLabel.text = comment.user_name;
    return cell;
}

@end
