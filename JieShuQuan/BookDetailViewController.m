//
//  BookDetailViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_book.imageHref]];
    _nameLabel.text = _book.name;
    _authorsLabel.text = [_book authorsString];
    _publisherLabel.text = _book.publisher;
    _publishDateLabel.text = _book.publishDate;
    _priceLabel.text = _book.price;
    _discriptionLabel.text = _book.description;
    _authorInfoLabel.text = _book.authorInfo;
}

- (IBAction)addBook:(id)sender {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
    [newBook setValue:_book.name forKey:@"name"];
    [newBook setValue:_book.authors forKey:@"authors"];
    [newBook setValue:UIImageJPEGRepresentation(_bookImageView.image, 1.0)  forKey:@"imageData"];
    [newBook setValue:_book.description forKey:@"bookDescription"];
    [newBook setValue:_book.authorInfo forKey:@"authorInfo"];
    [newBook setValue:_book.price forKey:@"price"];
    [newBook setValue:_book.publisher forKey:@"publisher"];
    [newBook setValue:_book.bookId forKey:@"bookId"];
    [newBook setValue:_book.publishDate forKey:@"publishDate"];
    
    [delegate saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
