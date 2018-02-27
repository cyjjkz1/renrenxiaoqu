//
//  LoginTextfield.m
//  Community_http
//
//  Created by mac on 2017/10/20.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "LoginTextfield.h"

@implementation LoginTextfield
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetHeight(frame)/2.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds;
{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 5; //像左边偏15
    return iconRect;
}
@end
