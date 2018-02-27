//
//  PesonalCell.m
//  Community
//
//  Created by liuchun on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "PesonalCell.h"

@interface PesonalCell ()
@property (nonatomic, weak) UIButton *btn;


@end

@implementation PesonalCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(22 * BILI_WIDTH, 10 * BILI_WIDTH, 200 * BILI_WIDTH, 20 * BILI_WIDTH);
    btn.centerY = self.contentView.centerY;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn setTitleColor:BNColorRGB(125, 125, 125) forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [self.contentView addSubview:btn];
    _btn = btn;
}


- (void)handleCellData:(NSDictionary *)data;
{
    [_btn setTitle:data[@"title"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:data[@"imageName"]] forState:UIControlStateNormal];
}


@end
