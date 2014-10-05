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
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"

@interface ChangeNameViewController ()
@property (nonatomic, strong) User *currentUser;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [UserManager currentUser];
    _nameTextField.text = _nameString;
    _nameTextField.delegate = self;
    [_nameTextField becomeFirstResponder];
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

- (IBAction)backgroundViewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)saveInput:(id)sender {
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [_nameTextField resignFirstResponder];
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
        
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [self enableCancelButton];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改用户名失败"];
            return;
        }
        if (data) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改用户名成功"];
            _currentUser.userName = _nameTextField.text;
            [[UserStore sharedStore] saveUserToCoreData:_currentUser];
            
            [self popSelf];
        }
    }];
}

@end
