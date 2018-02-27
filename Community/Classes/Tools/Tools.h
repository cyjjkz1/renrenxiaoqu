//
//  Tools.h
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Tools : NSObject


+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                              textColor:(UIColor *)color
                                               textFont:(UIFont *)font
                                             colorRange:(NSRange)colorRange;
+(CGFloat)caleHeightWithTitle:(NSString *)title font:(UIFont *)titleFont width:(CGFloat)width;
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)titleFont height:(CGFloat)height;
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
+ (UIImage *)createUploadDefaultBackGroundImage;
+ (NSArray*)allFilesAtPath:(NSString*)dirString includeFolder:(BOOL)includeFolder;

+ (NSString *)getDocumentPath;

+ (NSString *)changeStempWithDateString:(NSInteger)stemp;

@end
