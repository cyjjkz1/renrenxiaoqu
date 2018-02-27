//
//  Tools.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "Tools.h"

@implementation Tools


+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                              textColor:(UIColor *)color
                                               textFont:(UIFont *)font
                                             colorRange:(NSRange)colorRange
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary * attributes1 = @{NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : color};
    [attributedString addAttributes:attributes1 range:colorRange];

    return attributedString;
}


+(CGFloat)caleHeightWithTitle:(NSString *)title font:(UIFont *)titleFont width:(CGFloat)width
{
    CGSize sizeTitle;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil];
    sizeTitle = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return ceilf(sizeTitle.height);
}

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)titleFont height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil];
    CGSize sizeTitle = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return ceil(sizeTitle.width);
}


+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)createUploadDefaultBackGroundImage
{
    UIGraphicsBeginImageContext(CGSizeMake(90, 90));   //开始画线
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    CGContextSetLineCap(currentContext, kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[2] = {8,4};
    CGContextSetLineDash(currentContext, 0, lengths, 2);
    CGContextSetLineWidth(currentContext, 1);
    [UIColorFromRGB(0xc5c5c5) setStroke];
    [UIColorFromRGB(0xe7e7e7) setFill];
    CGContextAddRect(currentContext, CGRectMake(1, 1, 90-2, 90-2));
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGContextRestoreGState(currentContext);
    
    CGContextSaveGState(currentContext);
    CGContextAddRect(currentContext, CGRectMake((90 - 6)/2.0, 20, 6, 90 - 20 * 2));
    CGContextAddRect(currentContext, CGRectMake(20, (90 - 6)/2.0, 90 - 20 * 2, 6));
    [[UIColor whiteColor] setFill];
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
    
    UIImage *uploadBKImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return uploadBKImg;
}


//获取文件目录下的文件名，可选则是否包含文件夹
+ (NSArray*)allFilesAtPath:(NSString*)dirString includeFolder:(BOOL)includeFolder{
    
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    if (includeFolder == YES) {
        //返回所有文件及文件夹名称
        return tempArray;
    }
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                
                [array addObject:fullPath];
                
            }
            
        }
        
    }
    //只返回所有文件名称，不包含文件夹
    return array;
    
}

+ (NSString *)getDocumentPath
{
   return  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)changeStempWithDateString:(NSInteger)stemp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:stemp/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *str = [formatter stringFromDate:date];
    
    
    return str;
}



@end
