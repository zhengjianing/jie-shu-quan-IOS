//
//  BookDetailTableViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/13/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Book;

@interface BookDetailTableViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeAvailabilityButton;
@property (strong, nonatomic) IBOutlet UILabel *existenceLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeExistenceButton;

- (IBAction)changeAvailability:(id)sender;
- (IBAction)changeExistence:(id)sender;

@property (strong, nonatomic) Book *book;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

//current existence & availability state
@property (assign, nonatomic) BOOL existenceStatus;
@property (assign, nonatomic) BOOL availabilityStatus;
//keep track which of the two properties above is being modified right now
@property (assign, nonatomic) BOOL isChangingAvailability;
@property (assign, nonatomic) BOOL isAdding;
@property (assign, nonatomic) BOOL isDeleting;

@end
