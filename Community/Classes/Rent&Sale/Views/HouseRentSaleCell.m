//
//  HouseRentSaleCell.m
//  Community_http
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "HouseRentSaleCell.h"
#import "IconTextLabel.h"
#import "cc_macro.h"

@interface HouseRentSaleCell()
@property (nonatomic, weak) UIImageView *cellIcon;
@property (nonatomic, weak) UILabel *rentSaleLabel;
@property (nonatomic, weak) IconTextLabel *distanceLabel;
@property (nonatomic, weak) IconTextLabel *timeLabel;
@property (nonatomic, weak) UILabel *rentOrSaleLabel;
@end

@implementation HouseRentSaleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCellSubview];
    }
    return self;
}
- (void)addCellSubview
{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_room"]];
    icon.frame = CGRectMake(12 * BILI_WIDTH, 14 * BILI_WIDTH , 88 * BILI_WIDTH, 64 * BILI_WIDTH);
    icon.layer.cornerRadius = 1;
    icon.layer.masksToBounds = YES;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX + 10, 9, kCCScreenWidth - icon.maxX - 10 - 10, 24 * BILI_WIDTH)];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    
    
    IconTextLabel *dis = [IconTextLabel buttonWithType:UIButtonTypeCustom];
    dis.titleLabel.textAlignment = NSTextAlignmentLeft;
    dis.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [dis setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    dis.enabled = NO;
    dis.frame = CGRectMake(label.x, label.maxY, label.w, 24 * BILI_WIDTH);
    
    
    IconTextLabel *time = [IconTextLabel buttonWithType:UIButtonTypeCustom];
    time.titleLabel.textAlignment = NSTextAlignmentLeft;
    time.enabled = NO;
    time.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [time setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    time.frame = CGRectMake(label.x, dis.maxY, label.w - 60 * BILI_WIDTH, 24 * BILI_WIDTH);
    
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(time.maxX, time.y, 60 * BILI_WIDTH, 24 * BILI_WIDTH)];
    type.textAlignment = NSTextAlignmentCenter;
    type.textColor = UIColorFromRGB(0x0080ff);
    type.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    
    [self.contentView addSubview:icon];
    [self.contentView addSubview:label];
    [self.contentView addSubview:dis];
    [self.contentView addSubview:time];
    [self.contentView addSubview:type];
    self.cellIcon = icon;
    self.rentSaleLabel = label;
    self.distanceLabel = dis;
    self.timeLabel = time;
    self.rentOrSaleLabel = type;
    [self.distanceLabel setImage:[UIImage imageNamed:@"icon_dingwei"] forState:UIControlStateNormal];
    [self.timeLabel setImage:[UIImage imageNamed:@"icon_time"] forState:UIControlStateNormal];
}

- (void)handleCellWithInfo:(RentInfoModel *)rentInfo
{
    [self.cellIcon sd_setImageWithURL:[NSURL URLWithString:rentInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"info_defalut"]];
    [self.rentSaleLabel setText:rentInfo.title];
    [self.distanceLabel setTitle:rentInfo.address forState:UIControlStateNormal];
    [self.timeLabel setTitle:rentInfo.date forState:UIControlStateNormal];
    [self.rentOrSaleLabel setText:rentInfo.type];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
