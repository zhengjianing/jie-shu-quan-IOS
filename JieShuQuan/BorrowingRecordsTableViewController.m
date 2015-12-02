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
#import "CustomColor.h"

static NSString *kReuseIdentifier = @"recordsCell";
static NSString *kBorrowingRecordsViewControllerTitle = @"借入记录";
static NSString *kBookStatusTextKey = @"text";
static NSString *kBookStatusColorKey = @"color";
static NSString *kBookStatusRequestTimeKey = @"time";
static NSString *kDefaultString = @"--";

@interface BorrowingRecordsTableViewController () <RecordsCellDelegate, PreLoginDelegate>

@property(nonatomic, strong) RecordsViewModel *viewModel;
@property(nonatomic, strong) PreLoginView *preLoginView;
@property(nonatomic, strong) LoginViewController *loginViewController;
@property(nonatomic, strong) Record *pressedRecord;
@property(nonatomic, strong) RecordsCell *cellOfPressedRecord;

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
    cell.borrowerNameLabel.text = [record.lenderName length] == 0 ? kDefaultString : [NSString stringWithFormat:@"借%@的书", record.lenderName];

    [self setCellBookStatusForCell:cell withRecord:record];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma - mark RecordsCellDelegate

- (void)bookStatusButtonClicked:(id)sender {
    UIButton *pressedButton = sender;
    self.cellOfPressedRecord = (RecordsCell *) pressedButton.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell: self.cellOfPressedRecord];
    self.pressedRecord = self.viewModel.borrowingRecordsArray[(NSUInteger) indexPath.row];
    [self returnABook];
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
    }                                       failure:^(NSString *errorMessage) {
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setCellBookStatusForCell:(RecordsCell *)cell withRecord:(Record *)record {
    if (![record.bookStatus isEqual:[NSNull null]]) {
        [cell.bookStatusButton setTitle:self.viewModel.borrowingBookStatusDic[record.bookStatus][kBookStatusTextKey] forState:UIControlStateNormal];
        NSString *timeText = [record valueForKey:self.viewModel.lendingBookStatusDic[record.bookStatus][kBookStatusRequestTimeKey]];

        if (![timeText isEqual:[NSNull null]]) {
            cell.applicationTimeLabel.text = [timeText substringToIndex:10];
        }
    }

    if ([record.bookStatus isEqual:@"approved"]) {
        [cell.bookStatusButton setEnabled:YES];
        cell.bookStatusButton.layer.borderColor = [CustomColor mainRedColor].CGColor;
        cell.bookStatusButton.layer.cornerRadius = 5.0;
        cell.bookStatusButton.layer.borderWidth = 0.5;
        cell.bookStatusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        [cell.bookStatusButton setEnabled:NO];
    }

    [cell.bookStatusButton setTitleColor:self.viewModel.lendingBookStatusDic[record.bookStatus][kBookStatusColorKey] forState:UIControlStateNormal];
}

- (void)returnABook {
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    Record *record = self.pressedRecord;
    [RecordsViewModel returnBorrowRecordWithBookId:record.bookId borrowerId:self.pressedRecord.borrowerId lenderId:record.lenderId success:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"还书成功"];
        [self.cellOfPressedRecord.bookStatusButton setTitle:self.viewModel.borrowingBookStatusDic[@"returned"][kBookStatusTextKey] forState:UIControlStateNormal];
        [self.cellOfPressedRecord.bookStatusButton setTitleColor:self.viewModel.borrowingBookStatusDic[@"returned"][kBookStatusColorKey] forState:UIControlStateNormal];
        [self setButtonToDisableState:self.cellOfPressedRecord.bookStatusButton];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }                                      failure:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }];
}

- (void)setButtonToDisableState:(UIButton *)button {
    [button setEnabled:NO];
    button.layer.borderWidth = 0;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

@end