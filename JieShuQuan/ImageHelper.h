//
//  ImageHelper.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

+ (UIImage*)scaleImage:(UIImage*)originalImage toSize:(CGSize)newSize;

@end
