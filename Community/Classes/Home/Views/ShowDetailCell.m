//
//  ShowDetailCell.m
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ShowDetailCell.h"


@interface ShowDetailCell ()

@property (nonatomic, weak) UILabel *type;
@property (nonatomic, weak) UILabel *status;
@property (nonatomic, weak) UILabel *time;
@property (nonatomic, weak) UILabel *moneyLbl;

@end

@implementation ShowDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}


- (void)createCellSubViews
{
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 8 * BILI_WIDTH, 200, 17 * BILI_WIDTH)];
    type.textColor = [UIColor blackColor];
    type.font = [UIFont systemFontOfSize:16 * BILI_WIDTH];
    type.text = @"物业费";
    [self.contentView addSubview:type];
    _type = type;
    
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(type.x, type.maxY + 5 * BILI_WIDTH, 200, 12 * BILI_WIDTH)];
    status.textColor = UIColor_Gray_Text;
    status.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    status.text = @"支付成功";
    [self.contentView addSubview:status];
    _status = status;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(type.x, status.maxY + 5 * BILI_WIDTH, 200, 12 * BILI_WIDTH)];
    time.textColor = UIColor_Gray_Text;
    time.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    time.text = @"2016-06-30";
    [self.contentView addSubview:time];
    _time = time;
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 212 * BILI_WIDTH   , 14 * BILI_WIDTH, 200 * BILI_WIDTH , 13 * BILI_WIDTH)];
    moneyLbl.textColor = [UIColor blackColor];
    moneyLbl.textAlignment = NSTextAlignmentRight;
    moneyLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    moneyLbl.text = @"¥15.00";
    [self.contentView addSubview:moneyLbl];
    _moneyLbl = moneyLbl;
    
}

@end
