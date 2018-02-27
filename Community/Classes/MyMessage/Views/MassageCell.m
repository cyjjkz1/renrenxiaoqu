//
//  MassageCell.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MassageCell.h"

@interface MassageCell ()

@property (nonatomic, weak) UILabel *contentLbl;
@property (nonatomic, weak) UILabel *dateLbl;

@end

@implementation MassageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat iconH = 50 * BILI_WIDTH;
        UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14*BILI_WIDTH, 10*BILI_WIDTH, iconH, iconH)];
        phoneIcon.image = [UIImage imageNamed:@"msg_phone_icon"];
        [self.contentView addSubview:phoneIcon];
        
        UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(phoneIcon.maxX + 10*BILI_WIDTH, 21 * BILI_WIDTH, 186*BILI_WIDTH, 26 * BILI_WIDTH)];
        contentLbl.textColor = [UIColor blackColor];
        contentLbl.font = [UIFont systemFontOfSize:10*BILI_WIDTH];
        contentLbl.numberOfLines = 0;
        contentLbl.text = @"您好，本月电费200元，水费100元，天然气费1000元";
        [self.contentView addSubview:contentLbl];
        _contentLbl = contentLbl;
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215*BILI_WIDTH,52*BILI_WIDTH, 200 * BILI_WIDTH, 10*BILI_WIDTH)];
        dateLbl.textColor = [UIColor blackColor];
        dateLbl.font = [UIFont systemFontOfSize:10*BILI_WIDTH];
        dateLbl.textAlignment = NSTextAlignmentRight;
        dateLbl.text = @"昨天12：21";
        [self.contentView addSubview:dateLbl];
        _dateLbl = dateLbl;

    }
    return self;
}

- (void)setupCellWithDictonary:(NSDictionary *)dic
{
    _contentLbl.text = [dic valueNotNullForKey:@"content"];
    NSInteger time = [[dic valueNotNullForKey:@"createTime"] integerValue];
    _dateLbl.text = [self changeTime:time];
                     
}

- (NSString *)changeTime:(NSInteger)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *str = [formatter stringFromDate:date];
    
    return str;
}

@end
