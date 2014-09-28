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
    } else {
        // 由于会重用cell，因此前四个直辖市设置AccessoryType为None，会导致后面重用这四个cell时，虽然不执行if中的语句，但是AccessoryType仍然是None，使得在shouldPerformSegueWithIdentifier中判断出错而不执行跳转！！！因此即使在storyboard中已经指定使用DisclosureIndicator，此处仍然需要加上下面这句
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}

- (void)setMunicipalityForLocationWithIndexPath:(NSIndexPath *)indexPath
{
    [self.activityIndicator startAsynchAnimating];
    [self disableBackButton];
    self.changedLocation = [self.provinceArray objectAtIndex:indexPath.row];
    if ([self.changedLocation isEqualToString:self.oldLocation]) {
        [self.activityIndicator stopAsynchAnimating];
        [self popToControllerWithCountDownIndex:2];
        return;
    }
    [self changeUserLocation:self.changedLocation andPopToControllerWithCountDownIndex:2];
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
        [segue.destinationViewController setOldLocation:self.oldLocation];

    }
}

@end
