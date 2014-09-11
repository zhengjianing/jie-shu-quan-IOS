//
//  LoginViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-9.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationViewController.h"

@interface LoginViewController : AuthenticationViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *recoverPasswordButton;

- (IBAction)loginUser:(id)sender;
- (IBAction)recoverPassword:(id)sender;

@end
