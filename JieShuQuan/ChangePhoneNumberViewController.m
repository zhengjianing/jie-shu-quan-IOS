//
//  ChangePhoneNumberViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-29.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ChangePhoneNumberViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "CustomActivityIndicator.h"
#import "CustomAlert.h"
#import "FormatValidator.h"

@interface ChangePhoneNumberViewController ()
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ChangePhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [UserManager currentUser];
    _activityIndicator = [CustomActivityIndicator sharedActivityIndicator];
    _numberTextField.text = _numberString;
    _numberTextField.delegate = self;
    [_numberTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)disableCancelButton
{
    [_cancelButton setEnabled:NO];
}

- (void)enableCancelButton
{
    [_cancelButton setEnabled:YES];
}

- (IBAction)backgroundViewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)cancelInput:(id)sender {
    [self popSelf];
}

- (IBAction)saveInput:(id)sender {
    [_numberTextField resignFirstResponder];

    FormatValidator *validator = [[FormatValidator alloc] init];
    if ([validator isValidPhoneNumber:_numberTextField.text]) {
        [_activityIndicator startSynchAnimating];
        [self disableCancelButton];
        [self changeCurrentUserPhoneNumber];
    } else {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"手机号码不合法"];
    }
}

- (void)changeCurrentUserPhoneNumber
{
    NSMutableURLRequest *request = [RequestBuilder buildChangeUserPhoneNumberRequestWithUserId:_currentUser.userId accessToken:_currentUser.accessToken UserPhoneNumber:_numberTextField.text];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopSynchAnimating];
        [self enableCancelButton];

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改手机号码失败"];
            return;
        }
        if (data) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改手机号码成功"];
            _currentUser.phoneNumber = _numberTextField.text;
            [[UserStore sharedStore] saveUserToCoreData:_currentUser];
            
            [self popSelf];
        }
    }];
}






















@end
