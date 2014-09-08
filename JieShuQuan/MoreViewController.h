//
//  LoginViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterViewController;

@interface MoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) RegisterViewController *registerController;

- (IBAction)loginLogout:(id)sender;

@end
