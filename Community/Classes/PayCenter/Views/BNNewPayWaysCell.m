//
//  BNNewPayWaysCell.m
//  NewWallet
//
//  Created by mac1 on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNNewPayWaysCell.h"

@interface BNNewPayWaysCell ()

@property (weak, nonatomic) UILabel *bankNameLabel;

@property (nonatomic) UIImageView *bankLogoImgV;
@property (weak, nonatomic) UIImageView *arrowImg;

@property (weak, nonatomic) UIImageView *selectedImageView;
@end

@implementation BNNewPayWaysCell

static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        cellHeight = 40*BILI_WIDTH;



        self.bankLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(25*BILI_WIDTH, (cellHeight-28*BILI_WIDTH)/2, 28*BILI_WIDTH, 28*BILI_WIDTH)];
        [self.contentView addSubview:_bankLogoImgV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(74*BILI_WIDTH, 0, SCREEN_WIDTH - (74+20)*BILI_WIDTH, cellHeight)];
        nameLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.bankNameLabel = nameLabel;
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (15+5)*BILI_WIDTH, (cellHeight - 15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        arrowImg.backgroundColor = [UIColor clearColor];
        arrowImg.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:arrowImg];
        _arrowImg = arrowImg;
        
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (15+5+20)*BILI_WIDTH, (cellHeight-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
        [self.contentView addSubview:selectImgV];
        self.selectedImageView = selectImgV;
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 1, SCREEN_WIDTH, 1)];
//        line.backgroundColor = UIColor_GrayLine;
//        [self.contentView addSubview:line];
    }
    return self;
}


- (void)drawDataWithInfo:(NSDictionary *)bankCardInfo selectedRow:(NSInteger)selectedRow row:(NSInteger)row payWayStatus:(NSDictionary *)pay_type_list
{
    self.bankNameLabel.textColor = [UIColor blackColor];
    NSString *bankName = [bankCardInfo valueNotNullForKey:@"card_name"];

    switch (row) {
        case 0: {
            //支付宝支付
            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_aliPay"];
            
            break;
        }
        case 1: {
            //微信支付 --(暂未开通);
            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_wechatPay"];
            _bankNameLabel.textColor = [UIColor grayColor];
            break;
        }
    }

    _arrowImg.hidden = YES;  //隐藏右箭头
    
    _bankNameLabel.text = bankName;

    if (selectedRow == row) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
