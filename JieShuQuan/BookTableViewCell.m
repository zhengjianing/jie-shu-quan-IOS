//
//  BookTableViewCell.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 8/24/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "BookTableViewCell.h"

@implementation BookTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _authorsLabel = [[UILabel alloc] init];
        _nameLabel = [[UILabel alloc] init];
        _bookImageView = [[UIImageView alloc] init];
    }
    return self;    
}

@end
