//
//  CityTableViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-24.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CityTableViewController.h"
#import "RequestBuilder.h"
#import "UserManager.h"
#import "UserStore.h"
#import "User.h"
#import "AlertHelper.h"
#import "CustomActivityIndicator.h"

@interface CityTableViewController ()

@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, copy) NSString *location;

@end

@implementation CityTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [UserManager currentUser];
    [self.view addSubview:self.activityIndicator];
}

- (void)disableBackButton
{
    [self.navigationItem.backBarButtonItem setEnabled:NO];
}

- (void)enableBackButton
{
    [self.navigationItem.backBarButtonItem setEnabled:YES];
}

- (void)popToSettingsPage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CustomActivityIndicator *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    _activityIndicator = [[CustomActivityIndicator alloc] init];
    return _activityIndicator;
}

- (void)changeUserLocation:(NSString *)location
{
    NSMutableURLRequest *request = [RequestBuilder buildChangeUserLocationRequestWithUserId:_currentUser.userId accessToken:_currentUser.accessToken location:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [_activityIndicator stopAnimating];
        [self enableBackButton];
        
        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            [AlertHelper showAlertWithMessage:@"修改位置失败" withAutoDismiss:YES];
            return;
        }
        if (data) {
            [AlertHelper showAlertWithMessage:@"修改位置成功" withAutoDismiss:YES];
            _currentUser.location = _location;
            [[UserStore sharedStore] saveUserToCoreData:_currentUser];
            
            [self popToSettingsPage];
        }
    }];
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
    [_activityIndicator startAnimating];
    [self disableBackButton];
    
    NSString *city = [_cityArray objectAtIndex:indexPath.row];
    NSString *location = [NSString stringWithFormat:@"%@,%@", _province, city];
    
    [self changeUserLocation:location];
}

@end
