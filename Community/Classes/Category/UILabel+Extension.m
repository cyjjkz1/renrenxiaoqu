//
//  UILabel+Extension.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void)setupWithFontSize:(CGFloat)font textColor:(UIColor *)color textAlign:(NSTextAlignment)align
{
    if (font != 0) {
        self.font = [UIFont systemFontOfSize:font];
    }
    
    if (color) {
        self.textColor = color;
    }
    
    self.textAlignment = align;
}

@end
