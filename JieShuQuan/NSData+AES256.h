//
//  NSData+AES256.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-8.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(AES256)
-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
@end