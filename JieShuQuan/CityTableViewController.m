//
//  CityTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-24.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CityTableViewController.h"
#import "SettingsTableViewController.h"

@implementation CityTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_cityArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.activityIndicator startAnimating];
    [self disableBackButton];
    NSString *city = [_cityArray objectAtIndex:indexPath.row];
    self.changedLocation = [NSString stringWithFormat:@"%@，%@", _province, city];
    if ([self.changedLocation isEqualToString:self.oldLocation]) {
        [self.activityIndicator stopAnimating];
        [self popToControllerWithCountDownIndex:3];
        return;
    }
    [self changeUserLocation:self.changedLocation andPopToControllerWithCountDownIndex:3];
}

@end
