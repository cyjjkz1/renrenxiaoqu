//
//  BNTools.m
//  Wallet
//
//  Created by mac on 15-1-5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNTools.h"

@implementation BNTools

+ (CGFloat)sizeFit:(CGFloat)size six:(CGFloat)six sixPlus:(CGFloat)sixPlus
{
    if (SCREEN_HEIGHT == 667 || SCREEN_WIDTH == 375) {
        //6
        return six;
    }else if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        //6plus
        return sixPlus;
    } else {
        //5s以下
        return size;
    }
}

+ (CGFloat)sizeFitfour:(CGFloat)four five:(CGFloat)five six:(CGFloat)six sixPlus:(CGFloat)sixPlus
{
    if (SCREEN_HEIGHT == 667 || SCREEN_WIDTH == 375) {
        //6
        return six;
    }else if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        //6plus
        return sixPlus;
    } else if (SCREEN_HEIGHT == 480) {
        //3.5寸-4s以下
        return four;
    } else {
        //4.0寸-5/5s
        return five;
    }
}

+ (CGFloat)sizeFitFour:(CGFloat)fourSize others:(CGFloat)otherSize;

{
    if (SCREEN_HEIGHT == 480 || SCREEN_WIDTH == 320) {
        
        return fourSize;
    } else {
        return otherSize;
    }
}
@end
