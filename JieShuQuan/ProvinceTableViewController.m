//
//  ProvinceTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-23.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ProvinceTableViewController.h"

@interface ProvinceTableViewController ()

@property (nonatomic, copy) NSMutableArray *provinceArray;

@end

@implementation ProvinceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _provinceArray = [[NSMutableArray alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *plistPath = [mainBundle pathForResource:@"city" ofType:@"plist"];
    
    NSArray *regionArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (id state in regionArray) {
        [_provinceArray addObject:[state valueForKey:@"state"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
