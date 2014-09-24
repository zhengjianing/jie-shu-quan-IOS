//
//  ChangeNameViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-22.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "AlertHelper.h"
#import "CustomActivityIndicator.h"

@interface ChangeNameViewController ()
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [UserManager currentUser];
    [self.view addSubview:self.activityIndicator];
    _nameTextField.text = _nameString;
    _nameTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)disableCancelButton
{
    [_cancelButton setEnabled:NO];
}

- (void)enableCancelButton
{
    [_cancelButton setEnabled:YES];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)saveInput:(id)sender {
    [_activityIndicator startAnimating];
    [self disableCancelButton];
    [self changeCurrentUserName];
}

- (IBAction)cancelInput:(id)sender {
    [self popSelf];
}

- (void)changeCurrentUserName
{
    NSMutableURLRequest *request = [RequestBuilder buildChangeUserNameRequestWithUserId:_currentUser.userId accessToken:_currentUser.accessToken UserName:_nameTextField.text];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];
        [self enableCancelButton];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"修改用户名失败" withAutoDismiss:YES];
            return;
        }
        if (data) {
            [AlertHelper showAlertWithMessage:@"修改用户名成功" withAutoDismiss:YES];
            _currentUser.userName = _nameTextField.text;
            [[UserStore sharedStore] saveUserToCoreData:_currentUser];
            
            [self popSelf];
        }
    }];
}

@end
