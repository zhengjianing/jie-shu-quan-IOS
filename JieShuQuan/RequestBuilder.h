//
//  RequestBuilder.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

+ (NSMutableURLRequest *)buildRegisterRequestWithUserName:(NSString *)userName email:(NSString *)email password:(NSString *)password;
+ (NSMutableURLRequest *)buildLoginRequestWithEmail:(NSString *)email password:(NSString *)password;
+ (NSMutableURLRequest *)buildAddBookRequestWithbookName:(NSString *)name
                                                 authors:(NSString *)authors
                                               imageHref:(NSString *)imageHref
                                             description:(NSString *)description
                                              authorInfo:(NSString *)authorInfo
                                                   price:(NSString *)price
                                               publisher:(NSString *)publisher
                                             publishDate:(NSString *)publishDate
                                                  bookId:(NSString *)bookId
                                               available:(BOOL)availability
                                                  userId:(NSString *)userId
                                              accessToke:(NSString *)accessToken;
+ (NSMutableURLRequest *)buildDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken;
+ (NSMutableURLRequest *)buildChangeBookAvailabilityRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken;
+ (NSMutableURLRequest *)buildFetchBooksRequestForUserId:(NSString *)userId;

@end
