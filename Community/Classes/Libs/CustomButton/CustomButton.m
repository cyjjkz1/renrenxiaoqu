//
//  CustomButton.m
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "CustomButton.h"

#define BILI ([UIScreen mainScreen].bounds.size.width/320)

@interface CustomButton ()

@property (nonatomic) CGFloat imgTopY;
@property (nonatomic) CGFloat imgHeight;
@property (nonatomic) CGFloat textBottomY;

@end
@implementation CustomButton

-(void)setUpWithImgTopY:(CGFloat)imgTopY imgHeight:(CGFloat)imgHeight textBottomY:(CGFloat)textBottomY
{
    _imgTopY = imgTopY;
    _imgHeight = imgHeight;
    _textBottomY = textBottomY;


    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15*BILI_WIDTH];
    self.titleLabel.textColor = UIColor_XiaoDaiCellGray_Text;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //图片的位置大小
    return CGRectMake((contentRect.size.width-_imgHeight)/2,_imgTopY, _imgHeight, _imgHeight);}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //文本的位置大小
    return CGRectMake(0, contentRect.size.height-_textBottomY-10*BILI_WIDTH, contentRect.size.width, 10*BILI_WIDTH);
}

@end


     
