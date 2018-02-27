//
//  RentHouseTopItem.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RentHouseTopItem.h"

@interface RentHouseTopItem ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) UIView *vLine;

@end

@implementation RentHouseTopItem


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
        label.textAlignment = 1;
        [self addSubview:label];
        _label = label;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"sanjiaoxing"];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UIView *vLine = [[UIView alloc] init];
        vLine.backgroundColor = UIColor_GrayLine;
        [self addSubview:vLine];
        _vLine = vLine;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _button = btn;
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat stringW = [Tools getTextWidthWithText:_label.text font:[UIFont systemFontOfSize:11 * BILI_WIDTH] height:self.h];
    _label.frame = CGRectMake((self.w - stringW)/2.0, 0, stringW, self.h);
    
    _imageView.frame = CGRectMake(_label.maxX + 6, 18 * BILI_WIDTH, 7, 7);
    
    _vLine.frame = CGRectMake(self.w - 1, (self.h - 22 * BILI_WIDTH)*0.5 , 1,  22 * BILI_WIDTH);
    
    _button.frame = CGRectMake(0, 0, self.w, self.h);
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    _label.textColor = selected ? UIColorFromRGB(0xffb368) : [UIColor blackColor];
}


- (void)btnClick:(UIButton *)btn
{
    self.clickedBlock(self.tag);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
