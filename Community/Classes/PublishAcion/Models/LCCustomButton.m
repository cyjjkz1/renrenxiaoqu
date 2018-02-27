//
//  LCCustomButton.m
//  Community
//
//  Created by mac1 on 16/9/7.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "LCCustomButton.h"

@implementation LCCustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(HouseTypeModel *)model
{
    _model = model;
    [self setTitle:model.text forState:UIControlStateNormal];
}

@end
