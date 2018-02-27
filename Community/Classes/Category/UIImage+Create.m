//
//  UIImage+Create.m
//  Community
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f,0.0f,size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}
@end
