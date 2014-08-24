//
//  LoginViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/21/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSString *userName;

- (IBAction)loginLogout:(id)sender;

@end
