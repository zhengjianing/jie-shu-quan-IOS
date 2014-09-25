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

@interface CreateCommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

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
    
    [self.view addSubview:self.activityIndicator];
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
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

- (void)postBookCommentWithContent:(NSString *)contentString
{
    NSMutableURLRequest *postRequest = [RequestBuilder buildPostBookCommentRequestWithBookId:_book.bookId userName:[[UserManager currentUser] userName] content:contentString];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"发表评论失败！" withAutoDismiss:YES];
            return ;
        }
        
        if (data) {
            [AlertHelper showAlertWithMessage:@"发表评论成功！" withAutoDismiss:YES];
            _commentTextView.text = @"";
        }
    }];
    
    
}

























@end
