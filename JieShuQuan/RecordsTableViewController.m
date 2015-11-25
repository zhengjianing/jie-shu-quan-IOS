//
//  RecordsTableViewController.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/20/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "RecordsTableViewController.h"
#import "LenderRecordsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "PreLoginView.h"
#import "UserManager.h"
#import "User.h"
#import "Record.h"
#import "RecordsViewModel.h"
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"

static NSString *kRecordsViewControllerTitle = @"借出记录";
static NSString *kReuseIdenrifier = @"lenderRecordsCell";
static NSString *kBookStatusTextKey = @"text";
static NSString *kBookStatusColorKey = @"color";
static NSString *kRequestFailErrorText = @"请求失败，请稍后重试";

@interface RecordsTableViewController ()<PreLoginDelegate>

@property (nonatomic, strong) NSMutableArray *lenderRecords;
@property (nonatomic, strong) PreLoginView *preLoginView;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) RecordsViewModel *viewModel;

@end

@implementation RecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    
    if ([UserManager isLogin]) {
        [self fetchLenderRecords];
    }else{
        [self.view addSubview:self.preLoginView];
    }
}

- (void) initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = kRecordsViewControllerTitle;
}

- (void) initData
{
    self.viewModel = [RecordsViewModel new];
    self.lenderRecords = [NSMutableArray new];
    self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)fetchLenderRecords
{
    [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
    [self.viewModel fetchLenderRecordsWithUserId:[UserManager currentUser].userId success:^(NSArray *lenderRecordsArray) {
        
        self.lenderRecords = [lenderRecordsArray mutableCopy];
        [self.tableView reloadData];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        
    } failure:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:kRequestFailErrorText];
        [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lenderRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LenderRecordsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReuseIdenrifier forIndexPath:indexPath];
    
    Record *record = self.lenderRecords[indexPath.row];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:record.bookImageURL]];
    cell.bookNameLabel.text = record.bookName;
    cell.borrowerNameLabel.text = [NSString stringWithFormat:@"借给%@的书",record.borrowerName];
    cell.applicationTimeLabel.text = record.applicationTime;
    cell.bookStatusLabel.text = self.viewModel.bookStatusDic[record.bookStatus][kBookStatusTextKey];
    cell.bookStatusLabel.textColor = self.viewModel.bookStatusDic[record.bookStatus][kBookStatusColorKey];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - PreLoginDelegate

-(void)login
{
    [self.navigationController pushViewController:self.loginViewController animated:YES];
}

- (PreLoginView *)preLoginView
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
