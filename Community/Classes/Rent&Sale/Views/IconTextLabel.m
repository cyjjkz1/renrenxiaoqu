//
//  IconTextLabel.m
//  Community_http
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "IconTextLabel.h"

@implementation IconTextLabel
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10 * BILI_WIDTH + 8, 0, CGRectGetWidth(self.frame) - 10 * BILI_WIDTH - 8, CGRectGetHeight(self.frame));
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (CGRectGetHeight(contentRect) - 10 * BILI_WIDTH)/2.0, 10 * BILI_WIDTH, 10 * BILI_WIDTH);
}
@end
