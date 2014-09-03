//
//  BookDetailViewController.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookStore.h"
#import "Book.h"

@interface BookDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorInfoLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBookButton;

- (IBAction)addBook:(id)sender;

@property (strong, nonatomic) Book *searchedBook;
@property (strong ,nonatomic) NSManagedObject *storedBook;
@property (nonatomic, assign) BOOL isFromStore;

@end
