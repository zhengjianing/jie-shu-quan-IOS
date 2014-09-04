//
//  BookDetailViewController.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BookStore.h"

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isFromStore) {
        [_bookImageView sd_setImageWithURL:[NSURL URLWithString:_searchedBook.imageHref]];
        _nameLabel.text = _searchedBook.name;
        _authorsLabel.text = [_searchedBook authorsString];
        _publisherLabel.text = _searchedBook.publisher;
        _publishDateLabel.text = _searchedBook.publishDate;
        _priceLabel.text = _searchedBook.price;
        _discriptionLabel.text = _searchedBook.description;
        _authorInfoLabel.text = _searchedBook.authorInfo;
    } else {
        [_bookImageView setImage:[UIImage imageWithData:[_storedBook valueForKey:@"imageData"]]];
        _nameLabel.text = [_storedBook valueForKey:@"name"];
        _authorsLabel.text = [[_storedBook valueForKey:@"authors"] componentsJoinedByString:@", "];
        _publisherLabel.text = [_storedBook valueForKey:@"publisher"];
        _publishDateLabel.text = [_storedBook valueForKey:@"publishDate"];
        _priceLabel.text = [_storedBook valueForKey:@"price"];
        _discriptionLabel.text = [_storedBook valueForKey:@"bookDescription"];
        _authorInfoLabel.text = [_storedBook valueForKey:@"authorInfo"];
    }
}

- (IBAction)addBook:(id)sender {
    NSArray *storedBooks = [[BookStore sharedStore] storedBooks];
    
    for (NSManagedObject *book in storedBooks) {
        if ([[book valueForKey:@"name"] isEqualToString:_searchedBook.name]
            && [[book valueForKey:@"authors"] isEqualToArray:_searchedBook.authors]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Book Already Exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
//            若用continue则跳出本次循环，继续下一次；若用return则直接跳出循环
//            continue;
            return;
        }
    }
    if (_searchedBook) {
        id delegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [delegate managedObjectContext];
        
        NSManagedObject *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
        [newBook setValue:_searchedBook.name forKey:@"name"];
        [newBook setValue:_searchedBook.authors forKey:@"authors"];
        [newBook setValue:UIImageJPEGRepresentation(_bookImageView.image, 1.0)  forKey:@"imageData"];
        [newBook setValue:_searchedBook.description forKey:@"bookDescription"];
        [newBook setValue:_searchedBook.authorInfo forKey:@"authorInfo"];
        [newBook setValue:_searchedBook.price forKey:@"price"];
        [newBook setValue:_searchedBook.publisher forKey:@"publisher"];
        [newBook setValue:_searchedBook.bookId forKey:@"bookId"];
        [newBook setValue:_searchedBook.publishDate forKey:@"publishDate"];
        
        [delegate saveContext];
        [[BookStore sharedStore] refreshStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
