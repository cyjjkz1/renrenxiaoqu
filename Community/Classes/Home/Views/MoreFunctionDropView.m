//
//  MoreFunctionDropView.m
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MoreFunctionDropView.h"

@interface MoreFunctionDropView ()



@end

@implementation MoreFunctionDropView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0x2287f3);
        CGFloat buttonH = frame.size.height/titles.count;
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, buttonH * i, frame.size.width - 30, buttonH);
            btn.tag = i + 1;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11 * BILI_WIDTH]];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAcion:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i != titles.count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, buttonH*(i + 1) - 1, frame.size.width - 10, 0.5)];
                line.backgroundColor = [UIColor blackColor];
                [self addSubview:line];
            }
        }
        
    }
    
    return self;
}

- (void)btnAcion:(UIButton *)btn
{
    _clickedBlock(btn.tag - 1);
}

@end
