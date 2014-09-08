//
//  NSString+AES256.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-8.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end
