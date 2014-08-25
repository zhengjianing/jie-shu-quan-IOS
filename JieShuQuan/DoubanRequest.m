//
//  DoubanRequest.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-2.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "DoubanRequest.h"
#import "DoubanHeaders.h"

@implementation DoubanRequest

+ (NSString *)serializeURL:(NSString *)baseURL withParams:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:baseURL];
    NSString *queryPrefix = url.query ? @"&":@"?";
    NSString *query = [DoubanRequest stringFromDictionary:params];
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *componentsArray = [NSMutableArray array];
    for (NSString *key in [dictionary allKeys])
    {
        [componentsArray addObject:[NSString stringWithFormat:@"%@=%@", key, [dictionary valueForKey:key]]];
    }
    return [componentsArray componentsJoinedByString:@"&"];
}

+ (DoubanRequest *)requestWithURL:(NSString *)url withParams:(NSDictionary *)params
{
    DoubanRequest *req = [[DoubanRequest alloc] init];
    req.url = url;
    req.params = params;
    return req;
}

- (void)connect
{
    NSString *urlString = [DoubanRequest serializeURL:self.url withParams:self.params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:[NSData data]];
    NSURLConnection *connection;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (NSMutableData *)postBody
{
    NSMutableData *body = [NSMutableData data];
    return body;
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", @"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", @"didReceiveData");
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataString:\n%@", dataString);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", @"connectionDidFinishLoading");
}

@end
