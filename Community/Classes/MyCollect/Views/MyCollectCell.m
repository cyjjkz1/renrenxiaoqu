//
//  MyCollectCell.m
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MyCollectCell.h"

@interface MyCollectCell ()

@property (nonatomic, weak) UIView *grayPoint;
@property (nonatomic, weak) UIImageView *selectFlag;
@property (nonatomic, weak) UILabel *desLbl;
@property (nonatomic, weak) UILabel *typeLbl;
@property (nonatomic, weak) UILabel *dateLbl;

@end

@implementation MyCollectCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat pointW = 9*BILI_WIDTH;
        UIView *grayPoint = [[UIView alloc] initWithFrame:CGRectMake(14 * BILI_WIDTH, (64*BILI_WIDTH - pointW) * 0.5, pointW, pointW)];
        grayPoint.backgroundColor = UIColorFromRGB(0xf6f6f6);
        grayPoint.layer.cornerRadius = pointW * 0.5;
        grayPoint.layer.masksToBounds = YES;
        [self.contentView addSubview:grayPoint];
        _grayPoint = grayPoint;
        
        CGFloat imgW = 15*BILI_WIDTH;
        UIImageView *selectFlag = [[UIImageView alloc] initWithFrame:CGRectMake(14 * BILI_WIDTH, (64*BILI_WIDTH - imgW) * 0.5, imgW, imgW)];
        selectFlag.image = [UIImage imageNamed:@"select_all"];
        selectFlag.hidden = YES;
        [self.contentView addSubview:selectFlag];
        _selectFlag = selectFlag;
        
        UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(35 * BILI_WIDTH, 8*BILI_WIDTH, SCREEN_WIDTH - 35*BILI_WIDTH, 13*BILI_WIDTH)];
        desLbl.numberOfLines = 1;
        desLbl.textColor = [UIColor blackColor];
        desLbl.text = @"五大花园精装修，家具家电齐全，优质小区";
        desLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        [self.contentView addSubview:desLbl];
        _desLbl = desLbl;
        
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(desLbl.x, desLbl.maxY + 7*BILI_WIDTH, 100, 11 * BILI_WIDTH)];
        type.textColor = UIColorFromRGB(0xb6bec1);
        type.text = @"租房";
        type.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        [self.contentView addSubview:type];
        _typeLbl = type;
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(desLbl.x, type.maxY + 7*BILI_WIDTH, 300, 11 * BILI_WIDTH)];
        dateLbl.textColor = UIColorFromRGB(0xb6bec1);
        dateLbl.text = @"16/06/22 15:38";
        dateLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        [self.contentView addSubview:dateLbl];
        _dateLbl = dateLbl;
    
    }
    return self;
}

- (void)setAllSelected:(BOOL)allSelected
{
    _allSelected = allSelected;
    if (allSelected) {
        _selectFlag.hidden = NO;
        _grayPoint.hidden = YES;
    }else{
        _selectFlag.hidden = YES;
        _grayPoint.hidden = NO;
    }
}

- (void)setInfoModel:(RentInfoModel *)infoModel
{
    _infoModel = infoModel;
    _desLbl.text = infoModel.theDescription;
    _typeLbl.text = infoModel.type;
    _dateLbl.text = infoModel.date;
}

@end
