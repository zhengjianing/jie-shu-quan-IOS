//
//  ImageHelper.m
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/22/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage*)scaleImage:(UIImage*)originalImage toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
