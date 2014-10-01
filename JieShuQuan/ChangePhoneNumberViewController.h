//
//  ChangePhoneNumberViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-29.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneNumberViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, copy) NSString *numberString;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)backgroundViewTouchDown:(id)sender;
- (IBAction)cancelInput:(id)sender;
- (IBAction)saveInput:(id)sender;
@end
