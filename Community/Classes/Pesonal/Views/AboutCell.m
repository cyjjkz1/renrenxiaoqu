//
//  AboutCell.m
//  Community
//
//  Created by mac1 on 2016/10/19.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AboutCell.h"

@interface AboutCell ()

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIImageView *rightArrow;
@property (nonatomic, weak) UIView *line;

@end

@implementation AboutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    UILabel *title = [[UILabel alloc] init];
    title.centerY = self.contentView.centerY;
    title.textColor = [UIColor lightGrayColor];
    title.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [self.contentView addSubview:title];
    _title = title;
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.image = [UIImage imageNamed:@"right_arrow"];
    [self.contentView addSubview:rightArrow];
    _rightArrow = rightArrow;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColor_GrayLine;
    [self.contentView addSubview:line];
    _line = line;
}
- (void)layoutSubviews
{
    _title.frame = CGRectMake(22 * BILI_WIDTH, 0, 100, 15 * BILI_WIDTH);
    _title.centerY = self.contentView.centerY;
    
    _rightArrow.frame = CGRectMake(SCREEN_WIDTH - 15 * BILI_WIDTH - 18, (self.contentView.h - 18) * 0.5, 18, 18);
    _line.frame = CGRectMake(14 * BILI_WIDTH, self.contentView.h - 0.5, SCREEN_WIDTH - 29 * BILI_WIDTH, 0.5);
    
}


- (void)setupCellWithDic:(NSDictionary *)dic
{
    _title.text = [dic valueNotNullForKey:@"title"];
}


@end
