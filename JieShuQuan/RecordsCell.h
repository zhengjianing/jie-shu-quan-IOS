//
//  RecordsCell.h
//  JieShuQuan
//
//  Created by Yanzi Li on 11/24/15.
//  Copyright © 2015 JNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordsCellDelegate <NSObject>

@required
- (void) bookStatusButtonClicked:(id)sender;

@end

@interface RecordsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *borrowerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *applicationTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *bookStatusButton;
@property (strong, nonatomic) id <RecordsCellDelegate> delegate;

@end
