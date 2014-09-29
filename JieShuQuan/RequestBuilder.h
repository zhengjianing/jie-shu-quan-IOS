//
//  RequestBuilder.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Book;

@interface RequestBuilder : NSObject

+ (NSMutableURLRequest *)buildRegisterRequestWithEmail:(NSString *)email password:(NSString *)password;
+ (NSMutableURLRequest *)buildLoginRequestWithEmail:(NSString *)email password:(NSString *)password;
+ (NSMutableURLRequest *)buildChangeUserNameRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken UserName:(NSString *)newName;
+ (NSMutableURLRequest *)buildChangeUserLocationRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken location:(NSString *)location;
+ (NSMutableURLRequest *)buildChangeUserPhoneNumberRequestWithUserId:(NSString *)userId accessToken:(NSString *)accessToken UserPhoneNumber:(NSString *)newNumber;


+ (NSMutableURLRequest *)buildDeleteBookRequestWithBookId:(NSString *)bookId userId:(NSString *)userId accessToke:(NSString *)accessToken;
+ (NSMutableURLRequest *)buildChangeBookAvailabilityRequestWithBookId:(NSString *)bookId available:(BOOL)availabilityState userId:(NSString *)userId accessToken:(NSString *)accessToken;
+ (NSMutableURLRequest *)buildFetchBooksRequestForUserId:(NSString *)userId;
+ (NSMutableURLRequest *)buildAddBookRequestWithBook:(Book *)book available:(BOOL)availability userId:(NSString *)userId accessToke:(NSString *)accessToken;


+ (NSMutableURLRequest *)buildFetchFriendsRequestForUserId:(NSString *)userId;
+ (NSMutableURLRequest *)buildFetchFriendsRequestForUserId:(NSString *)userId bookId:(NSString *)bookId;

// comment related requests
+ (NSMutableURLRequest *)buildGetBookCommentsRequestWithBookId:(NSString *)bookId;
+ (NSMutableURLRequest *)buildPostBookCommentRequestWithBookId:(NSString *)bookId userName:(NSString *)userName content:(NSString *)content;

@end
