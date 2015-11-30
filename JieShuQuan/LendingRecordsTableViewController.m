//
//  LendingRecordsTableViewController.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/20/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//
#import "LendingRecordsTableViewController.h"
#import "RecordsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "RecordsViewModel.h"
#import "PreLoginView.h"
#import "UserManager.h"
#import "User.h"
#import "Record.h"
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"
#import "CustomColor.h"

static NSString *kRecordsViewControllerTitle = @"借出记录";
static NSString *kReuseIdentifier = @"recordsCell";
static NSString *kBookStatusTextKey = @"text";
static NSString *kBookStatusColorKey = @"color";
static NSString *kBookStatusRequestTimeKey = @"time";
static NSString *kRequestFailErrorText = @"请求失败，请稍后重试";
static NSString *kDefaultString = @"--";

@interface LendingRecordsTableViewController () <PreLoginDelegate, UIActionSheetDelegate, RecordsCellDelegate>

@property(nonatomic, strong) PreLoginView *preLoginView;
@property(nonatomic, strong) LoginViewController *loginViewController;
@property(nonatomic, strong) RecordsViewModel *viewModel;
@property(nonatomic, strong) Record *pressedRecord;
@property(nonatomic, strong) RecordsCell *cellOfPressedRecord;

@end

@implementation LendingRecordsTableViewController

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
        [self fetchLenderRecords];
    } else {
        [self.view addSubview:self.preLoginView];
    }
}

- (void)initView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = kRecordsViewControllerTitle;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordsCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"recordsCell"];
    self.loginViewController = (LoginViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)fetchLenderRecords {
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    [self.viewModel fetchLendingRecordsWithUserId:[UserManager currentUser].userId success:^(NSArray *lenderRecordsArray) {

        [self.tableView reloadData];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

    }                                     failure:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:kRequestFailErrorText];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - RecordsCell delegate

- (void)bookStatusButtonClicked:(id)sender {
    UIButton *pressedButton = sender;
    self.cellOfPressedRecord = (RecordsCell *) pressedButton.superview.superview;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.pressedRecord = self.viewModel.lendingRecordsArray[(NSUInteger) indexPath.row];

    UIActionSheet *handleBorrowBookRequestActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意借阅", @"拒绝借阅", nil];
    [handleBorrowBookRequestActionSheet showInView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.lendingRecordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordsCell *cell = (RecordsCell *) [self.tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    Record *record = self.viewModel.lendingRecordsArray[(NSUInteger) indexPath.row];
    if (![record.bookImageURL isEqual:[NSNull null]]) {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:record.bookImageURL]];
    }
    cell.bookNameLabel.text = [record.bookName isEqual:[NSNull null]] ? kDefaultString : record.bookName;
    cell.borrowerNameLabel.text = [record.borrowerName isEqual:[NSNull null]] ? kDefaultString : [NSString stringWithFormat:@"借给：%@", record.borrowerName];

    [self setCellBookStatusForCell:cell withRecord:record];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - PreLoginDelegate

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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self approveABorrowRequest];
    } else if (buttonIndex == 1) {
        [self declineABorrowRequest];
    }
}

#pragma mark - private methods

- (void)setCellBookStatusForCell:(RecordsCell *)cell withRecord:(Record *)record {
    if (![record.bookStatus isEqual:[NSNull null]]) {
        [cell.bookStatusButton setTitle:self.viewModel.lendingBookStatusDic[record.bookStatus][kBookStatusTextKey] forState:UIControlStateNormal];
        NSString *timeText = [record valueForKey:self.viewModel.lendingBookStatusDic[record.bookStatus][kBookStatusRequestTimeKey]];

        if (![timeText isEqual:[NSNull null]]) {
            cell.applicationTimeLabel.text = [timeText substringToIndex:10];
        }
    }

    if ([record.bookStatus isEqual:@"pending"]) {
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

- (void)approveABorrowRequest {
    Record *record = self.pressedRecord;
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    [RecordsViewModel approveBorrowRecordWithBookId:record.bookId borrowerId:self.pressedRecord.borrowerId lenderId:record.lenderId success:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"同意该借书请求成功"];
        [self.cellOfPressedRecord.bookStatusButton setTitle:self.viewModel.lendingBookStatusDic[@"approved"][kBookStatusTextKey] forState:UIControlStateNormal];
        [self.cellOfPressedRecord.bookStatusButton setTitleColor:self.viewModel.lendingBookStatusDic[@"approved"][kBookStatusColorKey] forState:UIControlStateNormal];
        [self setButtonToDisableState:self.cellOfPressedRecord.bookStatusButton];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }                                       failure:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:kRequestFailErrorText];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }];
}

- (void)declineABorrowRequest {
    Record *record = self.pressedRecord;
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    [RecordsViewModel declineBorrowRecordWithBookId:record.bookId borrowerId:record.borrowerId lenderId:record.lenderId success:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"拒绝该借书请求成功"];
        [self.cellOfPressedRecord.bookStatusButton setTitle:self.viewModel.lendingBookStatusDic[@"declined"][kBookStatusTextKey] forState:UIControlStateNormal];
        [self.cellOfPressedRecord.bookStatusButton setTitleColor:self.viewModel.lendingBookStatusDic[@"declined"][kBookStatusColorKey] forState:UIControlStateNormal];
        [self setButtonToDisableState:self.cellOfPressedRecord.bookStatusButton];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }                                       failure:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:kRequestFailErrorText];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
    }];
}

- (void)setButtonToDisableState:(UIButton *)button {
    [button setEnabled:NO];
    button.layer.borderWidth = 0;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
