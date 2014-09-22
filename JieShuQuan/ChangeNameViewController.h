//
//  ChangeNameViewController.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-22.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNameViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)saveInput:(id)sender;
- (IBAction)cancelInput:(id)sender;
@end
