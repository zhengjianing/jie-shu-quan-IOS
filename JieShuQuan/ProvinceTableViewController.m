//
//  ProvinceTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-23.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ProvinceTableViewController.h"
#import "CityTableViewController.h"

@interface ProvinceTableViewController ()

@property (nonatomic, copy) NSMutableArray *provinceArray;
@property (nonatomic, copy) NSMutableArray *citiesArray;

@end

@implementation ProvinceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _provinceArray = [[NSMutableArray alloc] init];
    _citiesArray = [[NSMutableArray alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *plistPath = [mainBundle pathForResource:@"city" ofType:@"plist"];
    
    NSArray *regionArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (id state in regionArray) {
        [_provinceArray addObject:[state valueForKey:@"state"]];
        [_citiesArray addObject:[state valueForKey:@"cities"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"provinceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_provinceArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if ([segue.destinationViewController isKindOfClass:[CityTableViewController class]]) {
            [segue.destinationViewController setCityArray:[_citiesArray objectAtIndex:indexPath.row]];
        }
    }
}

@end
