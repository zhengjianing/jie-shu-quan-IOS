//
//  ProvinceTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-23.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "ProvinceTableViewController.h"
#import "CityTableViewController.h"

@implementation ProvinceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"provinceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.provinceArray objectAtIndex:indexPath.row];
    if ([[self.citiesArray objectAtIndex:indexPath.row] count] == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)setMunicipalityForLocationWithIndexPath:(NSIndexPath *)indexPath
{
    [self.activityIndicator startAnimating];
    [self disableBackButton];
    self.location = [self.provinceArray objectAtIndex:indexPath.row];
    [self changeUserLocation:self.location andPopToControllerWithCountDownIndex:2];
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([sender accessoryType] == UITableViewCellAccessoryDisclosureIndicator) {
        return YES;
    }
    [self setMunicipalityForLocationWithIndexPath:[self.tableView indexPathForCell:sender]];
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.destinationViewController isKindOfClass:[CityTableViewController class]]) {
        [segue.destinationViewController setProvince:[self.provinceArray objectAtIndex:indexPath.row]];
        [segue.destinationViewController setCityArray:[self.citiesArray objectAtIndex:indexPath.row]];
    }
}

@end
