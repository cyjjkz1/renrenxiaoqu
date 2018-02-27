//
//  CustomShareButton.m
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "CustomShareButton.h"

#define BILI ([UIScreen mainScreen].bounds.size.width/320)

@implementation CustomShareButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderColor = UIColorFromRGB(0xd2d2d2).CGColor;
//        self.layer.borderWidth = .5;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12*BILI];
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //图片的位置大小
    return CGRectMake((contentRect.size.width-45*BILI)/2, 5*BILI, 45*BILI, 45*BILI);}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //文本的位置大小
    return CGRectMake(0, contentRect.size.height*0.9-12*BILI, contentRect.size.width, 12*BILI);
}

@end


     
