//
//  HomeCell.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *typeLabel;
@property (nonatomic, weak) UILabel *despLable;
@property (nonatomic, weak) UIButton *timeBtn;
@property (nonatomic, weak) UIImageView *iconImageView;


@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"default_room"];
    [self.contentView addSubview:imageView];
    _iconImageView = imageView;

    UIColor *tempColor = UIColorFromRGB(0xbfbfbf);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [titleLabel sizeToFit];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *despLabel = [[UILabel alloc] init];
    despLabel.numberOfLines = 0;
    despLabel.textColor = [UIColor lightGrayColor];
    despLabel.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    [self.contentView addSubview:despLabel];
    _despLable = despLabel;
    
    /*
    UIButton *distance = [UIButton buttonWithType:UIButtonTypeCustom];
    distance.frame = CGRectMake(nameLabel.x, nameLabel.maxY + 9 * BILI_WIDTH, 200 * BILI_WIDTH, 14 * BILI_WIDTH);
    distance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    distance.titleLabel.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    [distance setImage:[UIImage imageNamed:@"distance_btn"] forState:UIControlStateNormal];
    [distance setTitle:@"距离1.22km" forState:UIControlStateNormal];
    [distance setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [distance setTitleColor:tempColor forState:UIControlStateNormal];
    distance.userInteractionEnabled = NO;
    [self.contentView addSubview:distance];
    _distanceBtn = distance;
    */
    
    UIButton *time = [UIButton buttonWithType:UIButtonTypeCustom];
    time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    time.titleLabel.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    [time setImage:[UIImage imageNamed:@"time_btn"] forState:UIControlStateNormal];
    [time setTitle:@"13：02" forState:UIControlStateNormal];
    [time setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [time setTitleColor:tempColor forState:UIControlStateNormal];
    time.userInteractionEnabled = NO;
    [self.contentView addSubview:time];
    _timeBtn = time;
    
    UILabel *type = [[UILabel alloc] init];
    type.text = @"二手车位";
    type.textAlignment = NSTextAlignmentRight;
    type.textColor = tempColor;
    type.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    [self.contentView addSubview:type];

    _typeLabel = type;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(12 * BILI_WIDTH, 13 * BILI_WIDTH, 88 * BILI_WIDTH, 65 * BILI_WIDTH);
    _titleLabel.frame = CGRectMake(_iconImageView.maxX + 12 * BILI_WIDTH, _iconImageView.x, 183 * BILI_WIDTH, 12 * BILI_WIDTH);
    _despLable.frame = CGRectMake(_titleLabel.x, _titleLabel.maxY + 5, _titleLabel.w, 30*BILI_WIDTH);
    _timeBtn.frame = CGRectMake(_titleLabel.x, 0, 200 * BILI_WIDTH, 14 * BILI_WIDTH);
    _timeBtn.maxY = _iconImageView.maxY;
    _typeLabel.frame = CGRectMake(SCREEN_WIDTH - 119 * BILI_WIDTH, 67 * BILI_WIDTH, 100 * BILI_WIDTH, 15 * BILI_WIDTH);
}

- (void)setRentInfo:(RentInfoModel *)rentInfo
{
//    _rentInfo = rentInfo;
//    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:rentInfo.imageUrl]] placeholderImage:[UIImage imageNamed:@"info_defalut"]];
    
    _titleLabel.text = rentInfo.title;
    [_titleLabel sizeToFit];
    
    _despLable.text = rentInfo.theDescription;
    [_despLable sizeToFit];
    
    [_timeBtn setTitle:rentInfo.date forState:UIControlStateNormal];
    _typeLabel.text = rentInfo.type;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:rentInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
    /*
    NSString *str = @"";
    if (rentInfo.address && ![rentInfo.address isEqualToString:@"null"]) {
        [str stringByAppendingString:rentInfo.address];
    }
    
    if (rentInfo.houseType && ![rentInfo.houseType isEqualToString:@"null"]) {
        [str stringByAppendingString:[NSString stringWithFormat:@" %@",rentInfo.houseType]];
    }
    
    if (rentInfo.decorationType && ![rentInfo.decorationType isEqualToString:@"null"]) {
        [str stringByAppendingString:[NSString stringWithFormat:@" %@",rentInfo.decorationType]];
    }
    if (rentInfo.direction && ![rentInfo.direction isEqualToString:@"null"]) {
        [str stringByAppendingString:[NSString stringWithFormat:@" %@",rentInfo.direction]];
    }
    
    if (rentInfo.payType && ![rentInfo.payType isEqualToString:@"null"]) {
        [str stringByAppendingString:[NSString stringWithFormat:@" %@",rentInfo.payType]];
    }
    
    
//    _nameLabel.text = str;
     */
}

@end
