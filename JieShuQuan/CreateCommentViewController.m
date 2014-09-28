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
#import "AlertHelper.h"
#import "CustomActivityIndicator.h"

static const NSString *kDefaultName = @"匿名用户";

@interface CreateCommentViewController ()

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

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
    
    _clearButton.layer.cornerRadius = 5.0;
    _submitButton.layer.cornerRadius = 5.0;
    
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];

    if (![UserManager isLogin]) {
        [self setAnonymityLabelAndSwichWithAnonymityState:YES];
    } else {
        [self setAnonymityLabelAndSwichWithAnonymityState:NO];
    }
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
    [_commentTextView resignFirstResponder];
    if ([_commentTextView.text isEqualToString:@""]) {
        [AlertHelper showAlertWithMessage:@"评论内容不能为空" withAutoDismiss:YES];
        return;
    }
    [_activityIndicator startAnimating];
    [self postBookCommentWithContent:_commentTextView.text];
}

- (IBAction)clearTextView:(id)sender {
    _commentTextView.text = @"";
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
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"发表评论失败！" withAutoDismiss:YES];
            return ;
        }
        
        if (data) {
            [AlertHelper showAlertWithMessage:@"发表评论成功！" withAutoDismiss:YES];
            _commentTextView.text = @"";
            [self popSelf];
        }
    }];
}

- (IBAction)switchAnonymity:(id)sender {
    BOOL newState = _anonymitySwitch.on;
    if (![UserManager isLogin]) {
        [self setAnonymityLabelAndSwichWithAnonymityState:(!newState)];
        [AlertHelper showAlertWithMessage:@"您尚未登录,\n目前只能匿名评论" withAutoDismiss:YES];
        return;
    }
    [self setAnonymityLabelAndSwichWithAnonymityState:(newState)];
}
@end
