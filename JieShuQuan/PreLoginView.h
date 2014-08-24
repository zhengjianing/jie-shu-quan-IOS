//
//  PreLoginView.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreLoginDelegate
- (void)login;
@end

@interface PreLoginView : UIView

@property (strong, nonatomic) id<PreLoginDelegate> delegate;

- (IBAction)login:(id)sender;

@end
