//
//  RenterInfoFirstCell.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RenterInfoFirstCell.h"

@implementation RenterInfoFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    CGFloat avatarH = 45*BILI_WIDTH;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(18*BILI_WIDTH, (63*BILI_WIDTH - avatarH) * 0.5, avatarH, avatarH)];
    avatar.image = [UIImage imageNamed:@"avatar_default"];
    [self.contentView addSubview:avatar];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(avatar.maxX + 10*BILI_WIDTH, 18 * BILI_WIDTH, 200, 13*BILI_WIDTH)];
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    name.text = @"豆角";
    [self.contentView addSubview:name];
    
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(name.x, name.maxY + 8 * BILI_WIDTH , 200, 12*BILI_WIDTH)];
    phoneNum.textColor = UIColor_Gray_Text;
    phoneNum.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    phoneNum.text = @"18200376000";
    [self.contentView addSubview:phoneNum];
    
}
@end
