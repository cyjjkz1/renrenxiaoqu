//
//  PasswordTextField.m
//  Community_http
//
//  Created by mac on 2017/10/20.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}

@end
