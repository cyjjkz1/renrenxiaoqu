//
//  ManagerCell.m
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ManagerCell.h"

@interface ManagerCell ()

@property (nonatomic, weak) UIView *whiteView;
@property (nonatomic, weak) UIImageView *avatar;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *address;
@property (nonatomic, weak) UIButton *callBtn;

@end

@implementation ManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 103*BILI_WIDTH)];
    contentView.backgroundColor = UIColor_Gray_BG;
    [self.contentView addSubview:contentView];
   
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(14 * BILI_WIDTH, 17 * BILI_WIDTH, SCREEN_WIDTH - 28*BILI_WIDTH, 86 * BILI_WIDTH)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.cornerRadius = 3 * BILI_WIDTH;
    whiteBGView.layer.masksToBounds = YES;
    [contentView addSubview:whiteBGView];
    _whiteView = whiteBGView;
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(11 * BILI_WIDTH, (whiteBGView.h - 57 * BILI_WIDTH) * 0.5, 57 * BILI_WIDTH, 57 * BILI_WIDTH)];
    avatar.image = [UIImage imageNamed:@"avatar_default"];
    [whiteBGView addSubview:avatar];
    _avatar = avatar;
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(11 * BILI_WIDTH + avatar.maxX, 26 * BILI_WIDTH, 200, 12 * BILI_WIDTH)];
    name.text= @"豆角(*******5123)";
    name.textColor = UIColor_Gray_Text;
    name.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    [whiteBGView addSubview:name];
    _name = name;
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(name.x, name.maxY + 15 * BILI_WIDTH , 260, 12 * BILI_WIDTH)];
    address.text= @"XXXX小区5栋1单元503";
    address.textColor = UIColor_Gray_Text;
    address.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    [whiteBGView addSubview:address];
    _address = address;
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(whiteBGView.w - 65 * BILI_WIDTH, 31 * BILI_WIDTH, 57*BILI_WIDTH, 26*BILI_WIDTH);
    [callBtn setBackgroundImage:[Tools imageWithColor:UIColorFromRGB(0xff9700) andSize:CGSizeMake(57*BILI_WIDTH, 26*BILI_WIDTH)] forState:UIControlStateNormal];
    callBtn.layer.cornerRadius = 4;
    callBtn.layer.masksToBounds = YES;
    callBtn.titleLabel.font = [UIFont systemFontOfSize:9 * BILI_WIDTH];
    [callBtn setTitle:@"联系TA" forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"tel"] forState:UIControlStateNormal];
    [callBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [callBtn addTarget:self action:@selector(callBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView addSubview:callBtn];
    _callBtn = callBtn;
}

- (void)callBtnAcion:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(callBtnAcion:)]) {
        [self.delegate callBtnAcion:button];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
   
    _whiteView.backgroundColor = highlighted ? BNColorRGB(255, 151, 0) : [UIColor whiteColor];
}

- (void)setupCellWithDic:(NSDictionary *)dic index:(NSIndexPath *)index;
{
    //头像
    NSString *avatarUrl = [UserInfo sharedUserInfo].avatarUrl;
    NSDictionary *photos = [dic valueNotNullForKey:@"photo"];
    if ([photos isKindOfClass:[NSDictionary class]]) {
        avatarUrl = [photos valueNotNullForKey:@"visitUrl"];
    }else if ([photos isKindOfClass:[NSString class]]){
        avatarUrl = avatarUrl;
    }
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    NSString *phoneNum = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"mobile"]];
    phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@"*******"];
    
    NSString *theName = [NSString stringWithFormat:@"%@%@",[dic valueNotNullForKey:@"firstName"],[dic valueNotNullForKey:@"lastName"]];
    if ([theName isEqualToString:@"nullnull"]) {
        _name.text = phoneNum;
    }else{
        _name.text = [NSString stringWithFormat:@"%@(%@)",theName,phoneNum];
    }
    
    NSString *address = [dic valueNotNullForKey:@"address"];
    
    if ([address isEqualToString:@"null"]) {
        _address.hidden = YES;
    }else{
          _address.text = address;
    }
    
    _callBtn.tag = index.row;
}


@end
