//
// Created by Yanzi Li on 11/27/15.
// Copyright (c) 2015 JNXZ. All rights reserved.
//

#import "BorrowingRecordsTableViewController.h"
#import "RecordsViewModel.h"
#import "UserManager.h"
#import "User.h"
#import "RecordsCell.h"
#import "Record.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"
#import "LoginViewController.h"
#import "PreLoginView.h"

static NSString *kReuseIdentifier = @"recordsCell";
static NSString *kBorrowingRecordsViewControllerTitle = @"借入记录";
static NSString *kBookStatusTextKey = @"text";
static NSString *kBookStatusColorKey = @"color";
static NSString *kBookStatusRequestTimeKey = @"time";
static NSString *kRequestFailErrorText = @"请求失败，请稍后重试";
static NSString *kDefaultString = @"--";

@interface BorrowingRecordsTableViewController () <RecordsCellDelegate, PreLoginDelegate>

@property(nonatomic, strong) RecordsViewModel *viewModel;
@property(nonatomic, strong) PreLoginView *preLoginView;
@property(nonatomic, strong) LoginViewController *loginViewController;

@end

@implementation BorrowingRecordsTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [RecordsViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    if ([UserManager isLogin]) {
        [self fetchBorrowingRecords];
    } else {
        [self.view addSubview:self.preLoginView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.borrowingRecordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordsCell *cell = (RecordsCell *) [self.tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    Record *record = self.viewModel.borrowingRecordsArray[(NSUInteger) indexPath.row];
    if (![record.bookImageURL isEqual:[NSNull null]]) {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:record.bookImageURL]];
    }
    cell.bookNameLabel.text = [record.bookName isEqual:[NSNull null]] ? kDefaultString : record.bookName;
    cell.borrowerNameLabel.text = [record.borrowerName isEqual:[NSNull null]] ? kDefaultString : [NSString stringWithFormat:@"借给：%@", record.borrowerName];

    if (![record.bookStatus isEqual:[NSNull null]]) {
        [cell.bookStatusButton setTitle:self.viewModel.bookStatusDic[record.bookStatus][kBookStatusTextKey] forState:UIControlStateNormal];
        NSString *timeText = [record valueForKey:self.viewModel.bookStatusDic[record.bookStatus][kBookStatusRequestTimeKey]];

        if (![timeText isEqual:[NSNull null]]) {
            cell.applicationTimeLabel.text = [timeText substringToIndex:10];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma - mark RecordsCellDelegate

- (void)bookStatusButtonClicked:(id)sender {

}

#pragma - mark PreLoginDelegate

- (void)login {
    [self.navigationController pushViewController:self.loginViewController animated:YES];
}

- (PreLoginView *)preLoginView {
    if (_preLoginView) {
        return _preLoginView;
    }
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"PreLoginView" owner:self options:nil];
    if ([topLevelObjs count] > 0) {
        _preLoginView = [topLevelObjs lastObject];
        _preLoginView.delegate = self;
    }
    return _preLoginView;
}

#pragma - mark private methods

- (void)initView {
    self.title = kBorrowingRecordsViewControllerTitle;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordsCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kReuseIdentifier];
    self.loginViewController = (LoginViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)fetchBorrowingRecords {
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    [self.viewModel fetchBorrowingRecordsWithUserId:[UserManager currentUser].userId success:^(NSArray *borrowingRecordsArray) {

        [self.tableView reloadData];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }                                       failure:^{
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [[CustomAlert sharedAlert] showAlertWithMessage:kRequestFailErrorText];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end