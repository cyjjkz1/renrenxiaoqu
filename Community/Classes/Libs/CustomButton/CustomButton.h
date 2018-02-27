//
//  CustomButton.h
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

-(void)setUpWithImgTopY:(CGFloat)imgTopY imgHeight:(CGFloat)imgHeight textBottomY:(CGFloat)textBottom;

-(CGRect) imageRectForContentRect:(CGRect)contentRect;

-(CGRect) titleRectForContentRect:(CGRect)contentRect;

@end
