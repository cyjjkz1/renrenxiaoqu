//
//  MyPublishCell.m
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MyPublishCell.h"

@interface MyPublishCell ()

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *desLabel;
@property (weak, nonatomic) UILabel *roomNumber;
@property (weak, nonatomic) UILabel *roomArea;
@property (weak, nonatomic) UILabel *decoration;
@property (weak, nonatomic) UILabel *price;

@property (nonatomic, weak) UIButton *publishBtn;
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation MyPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13 * BILI_WIDTH, 12 * BILI_WIDTH, 88 * BILI_WIDTH, 65 * BILI_WIDTH)];
    imageView.image = [UIImage imageNamed:@"default_room"];
    [self.contentView addSubview:imageView];
    _iconImageView = imageView;
    
    UIColor *tempColor = UIColorFromRGB(0xbfbfbf);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 12 * BILI_WIDTH, imageView.x, 183 * BILI_WIDTH, 30 * BILI_WIDTH)];
    nameLabel.text = @"高新区中和镇香榭国际 一室一厅 50平米 精装修 押一付一";
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    
    _desLabel = nameLabel;
    
    UILabel *roomNumber = [[UILabel alloc] init];
    roomNumber.frame = CGRectMake(nameLabel.x, nameLabel.maxY + 6 * BILI_WIDTH, SCREEN_WIDTH - 80*BILI_WIDTH - nameLabel.x, 25);
    roomNumber.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    roomNumber.numberOfLines = 0;
    roomNumber.text = @"编号：1101";
    roomNumber.textColor = tempColor;
    [self.contentView addSubview:roomNumber];
    _roomNumber = roomNumber;
    
    UILabel *roomArea = [[UILabel alloc] init];
    roomArea.frame = CGRectMake(roomNumber.x, roomNumber.maxY + 5 * BILI_WIDTH, 200 * BILI_WIDTH, 11 * BILI_WIDTH);
    roomArea.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    roomArea.text = @"80平米";
    roomArea.textColor = tempColor;
//    [self.contentView addSubview:roomArea];
    _roomArea = roomArea;
    
    
    UILabel *price = [[UILabel alloc] init];
//                      WithFrame:CGRectMake(SCREEN_WIDTH - 113 * BILI_WIDTH, roomArea.y, 100 * BILI_WIDTH, 11 * BILI_WIDTH)];
    price.frame = CGRectMake(SCREEN_WIDTH - 113*BILI_WIDTH, nameLabel.y, 100 * BILI_WIDTH, nameLabel.h);
    price.text = @"800元/月";
    price.textAlignment = NSTextAlignmentRight;
    price.textColor = tempColor;
    price.font = [UIFont boldSystemFontOfSize:11 * BILI_WIDTH];
    [self.contentView addSubview:price];
    _price = price;
    
    // 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(SCREEN_WIDTH - 72*BILI_WIDTH, price.maxY +  5 * BILI_WIDTH, 60 * BILI_WIDTH, 20 * BILI_WIDTH);
    btn.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:@"停止发布" forState:UIControlStateNormal];
    [btn setTitle:@"继续发布" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[Tools imageWithColor:UIColorFromRGB(0xff9700) andSize:CGSizeMake(100 * BILI_WIDTH, 11 * BILI_WIDTH)] forState:UIControlStateNormal];
     [btn setBackgroundImage:[Tools imageWithColor:UIColorFromRGB(0xcbcbcb) andSize:CGSizeMake(100 * BILI_WIDTH, 11 * BILI_WIDTH)] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    _publishBtn = btn;
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame =  CGRectMake(SCREEN_WIDTH - 72*BILI_WIDTH, btn.maxY +  5 * BILI_WIDTH, 60 * BILI_WIDTH, 20 * BILI_WIDTH);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [deleteBtn setTitle:@"删除发布" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[Tools imageWithColor:UIColorFromRGB(0xff9700) andSize:CGSizeMake(100 * BILI_WIDTH, 11 * BILI_WIDTH)] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[Tools imageWithColor:UIColorFromRGB(0xcbcbcb) andSize:CGSizeMake(100 * BILI_WIDTH, 11 * BILI_WIDTH)] forState:UIControlStateSelected];
    deleteBtn.layer.cornerRadius = 4;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    _deleteBtn = deleteBtn;
    
    
}

- (void)btnAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(publishBtnAction:)]) {
        [self.delegate publishBtnAction:button];
    }
}

- (void)deleteAcion:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(deleteBtnAction:)]) {
        [self.delegate deleteBtnAction:button];
    }

}

- (void)setupCellWithDictionary:(RentInfoModel *)model index:(NSIndexPath *)indexPath;
{
    //照片
//    id photo = [dic valueNotNullForKey:@"photos"];
//    NSString *photoUrl = @"";
//    if ([photo isKindOfClass:[NSArray class]]) {
//        photo = (NSArray *)photo;
//        if ([photo count] == 0) {
//          
//        }else{
//            photoUrl = [[photo objectAtIndex:0] valueWithNoDataForKey:@"visitUrl"];
//        }
//    }else{
////        photoUrl = photo;
//    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
    _desLabel.text = model.title;
//    _desLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[dic valueForKey:@"address"],[dic valueForKey:@"desp"],[dic valueForKey:@"decorationType"],[dic valueNotNullForKey:@"payType"]];
    
    _roomNumber.text = model.theDescription;
    [_roomNumber sizeToFit];
//    _roomNumber.text = [NSString stringWithFormat:@"编号：%@",[dic valueForKey:@"id"]];
    
    _price.text = [NSString stringWithFormat:@"%@元/月",model.price];
//    _price.text = [NSString stringWithFormat:@"%@元/月",[dic valueNotNullForKey:@"price"]];
    
    //状态
    NSString *status = model.status;
//    [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"status"]];
    _publishBtn.selected = ![status isEqualToString:@"1"];
    _publishBtn.tag = indexPath.row;
    
    _deleteBtn.tag = 999 + indexPath.row;
}

@end
