//
//  RecordsCell.m
//  JieShuQuan
//
//  Created by Yanzi Li on 11/24/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import "RecordsCell.h"

@implementation RecordsCell

- (IBAction)onClickBookStatusButton:(id)sender
{   
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookStatusButtonClicked:)]) {
        [self.delegate bookStatusButtonClicked:sender];
    }
}

@end
