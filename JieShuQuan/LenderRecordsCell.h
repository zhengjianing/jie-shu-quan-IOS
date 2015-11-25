//
//  LenderRecordsCell.h
//  JieShuQuan
//
//  Created by Yanzi Li on 11/24/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LenderRecordsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *borrowerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *applicationTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookStatusLabel;

@end
