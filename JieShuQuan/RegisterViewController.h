//
//  RegisterViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AuthenticationDelegate;

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)registerUser:(id)sender;
- (IBAction)emailHint:(id)sender;

@property (strong ,nonatomic) AuthenticationDelegate *authDelegate;

@end
