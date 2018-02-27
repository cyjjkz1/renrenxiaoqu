//
//  BNBaseTextField.m
//  Wallet
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseTextField.h"

@implementation BNBaseTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-60, bounds.size.height);
    return rect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-60, bounds.size.height);
    return rect;
}

//控制清除按钮位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectOffset([super clearButtonRectForBounds:bounds], -10, 0);
}
@end
