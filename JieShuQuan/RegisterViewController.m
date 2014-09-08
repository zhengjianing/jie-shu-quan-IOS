//
//  RegisterViewController.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-7.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "BookStore.h"
#import "UserStore.h"
#import "NSString+AES256.h"

@implementation RegisterViewController

static const NSString *kPostUserURL = @"http://jie-shu-quan.herokuapp.com/users.json";
static const NSString *kPasswordKey = @"key";

- (IBAction)registerUser:(id)sender {
    [self postRequestWithUserName:_userName.text email:_email.text password:_password.text];
}

- (void)postRequestWithUserName:(NSString *)name email:(NSString *)email password:(NSString *)password
{
    NSString *encrypedPassword = [password aes256_encrypt:(NSString *)kPasswordKey];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"user_name",
                              email, @"email",
                              encrypedPassword, @"password", nil];
    NSURL *postURL = [NSURL URLWithString:[kPostUserURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
    
    id object = [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:object];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    id userObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [[UserStore sharedStore] saveCurrentUserToUDAndDBByUserObject:userObject];
    [[BookStore sharedStore] refreshStoredBooks];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popLoginViewController" object:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", @"connectionDidFinishLoading");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popLoginViewController" object:self];
}

@end
