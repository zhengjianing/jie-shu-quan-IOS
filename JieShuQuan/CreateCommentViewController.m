//
//  CreateCommentViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/25/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "User.h"
#import "Book.h"
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"
#import <UMMobClick/MobClick.h>

static const NSString *kDefaultName = @"匿名用户";

@interface CreateCommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitItem;
@property (strong, nonatomic) IBOutlet UILabel *anonymityLabel;
@property (strong, nonatomic) IBOutlet UISwitch *anonymitySwitch;

- (IBAction)switchAnonymity:(id)sender;

@end

@implementation CreateCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_commentTextView becomeFirstResponder];
    _commentTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _commentTextView.layer.borderWidth = 0.5;
    _commentTextView.layer.cornerRadius = 5.0;

    if (![UserManager isLogin]) {
        [self setAnonymityLabelAndSwichWithAnonymityState:YES];
    } else {
        [self setAnonymityLabelAndSwichWithAnonymityState:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"createCommentPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"createCommentPage"];
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
}

- (void)setAnonymityLabelAndSwichWithAnonymityState:(BOOL)isOn
{
    _anonymitySwitch.on = isOn;
    if (isOn) {
        _anonymityLabel.textColor = [UIColor blackColor];
        return;
    }
    _anonymityLabel.textColor = [UIColor grayColor];
}

- (IBAction)backgroundViewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)submitComment:(id)sender {
    [MobClick event:@"submitCommentButtonPressed"];

    [_commentTextView resignFirstResponder];
    if ([_commentTextView.text isEqualToString:@""]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"评论内容不能为空"];
        return;
    }
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self postBookCommentWithContent:_commentTextView.text];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postBookCommentWithContent:(NSString *)contentString
{
    NSString *name = ([_anonymitySwitch isOn]) ? (NSString *)kDefaultName : [[UserManager currentUser] userName];
    
    NSMutableURLRequest *postRequest = [RequestBuilder buildPostBookCommentRequestWithBookId:_book.bookId userName:name content:contentString];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"发表评论失败"];
            return ;
        }
        
        if (data) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"发表评论成功"];
            _commentTextView.text = @"";
            [self popSelf];
        }
    }];
}

- (IBAction)switchAnonymity:(id)sender {
    [MobClick event:@"anonymityCommentButtonPressed"];

    BOOL newState = _anonymitySwitch.on;
    if (![UserManager isLogin]) {
        [self setAnonymityLabelAndSwichWithAnonymityState:(!newState)];
        [[CustomAlert sharedAlert] showAlertWithMessage:@"您尚未登录,只能匿名评论"];
        return;
    }
    [self setAnonymityLabelAndSwichWithAnonymityState:(newState)];
}
@end
