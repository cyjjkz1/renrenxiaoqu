//
//  PesonInfoCell.m
//  Community
//
//  Created by mac1 on 16/6/29.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "PesonInfoCell.h"

@interface PesonInfoCell()

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UILabel *subTitle;
@property (nonatomic, weak) UIImageView *rightArrow;

@property (nonatomic, weak) UIView *line;

@end

@implementation PesonInfoCell

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
    
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.textColor = [UIColor blackColor];
    subTitle.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    subTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:subTitle];
    _subTitle = subTitle;
    
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

    if (_rightArrow.hidden == YES) {
         _subTitle.frame = CGRectMake(SCREEN_WIDTH - 215 * BILI_WIDTH, _title.y, 200*BILI_WIDTH, 15 * BILI_WIDTH);
    }else{
        _subTitle.frame = CGRectMake(_rightArrow.x - 200*BILI_WIDTH - 5, _title.y, 200*BILI_WIDTH, 15 * BILI_WIDTH);
    }
    
    
}

- (void)setupCellWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath sectionTotleRows:(NSInteger)totals
{
    
    if ((indexPath.section == 2 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0)){
        [self notHiddenSubtile];
    }else{
        [self notHiddenSubtileAndRightArrow];
    }
    
    
    _line.hidden = indexPath.row + 1 == totals;
    _title.text = dic[@"title"];
    
    UserInfo *user = [UserInfo sharedUserInfo];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://姓名
                {
                    if (user.userName && user.userName.length >0 && ![user.userName isEqualToString:@"nullnull"]) {
                        _subTitle.text = user.userName;
                    }else{
                        _subTitle.text = @"_ _";
                    }
                    
                }
                    break;
                case 1://性别
                {
                    if (user.sex && user.sex.length >0 && ![user.sex isEqualToString:@"null"]) {
                        _subTitle.text = user.sex;
                    }else{
                        _subTitle.text = @"_ _";
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0://身份
                {
                    if (user.status && user.status.length >0 && ![user.status isEqualToString:@"null"]) {
                        _subTitle.text = user.status;
                    }else{
                        _subTitle.text = @"_ _";
                    }
                }
                    break;
                case 1://小区
                {
                    if (user.villige && user.villige.length >0 && ![user.villige isEqualToString:@"null"]) {
                        _subTitle.text = user.villige;
                    }else{
                        _subTitle.text = @"_ _";
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0://电话号码
                {
                    if (user.phoneNumber && user.phoneNumber.length >0 && ![user.phoneNumber isEqualToString:@"null"]) {
                        _subTitle.text = [user.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }else{
                        _subTitle.text = @"***********";
                    }

                    
                }
                    break;
                case 1://无
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
//
//    if ([dic objectForKey:@"subTitle"]) {
//        _subTitle.text = [dic objectForKey:@"subTitle"];
//    }
    
}

- (void)notHiddenAvatar
{
    _subTitle.hidden = YES;
    _rightArrow.hidden = YES;
}

- (void)notHiddenSubtile
{
    _subTitle.hidden = NO;
    _rightArrow.hidden = YES;
}

- (void)notHiddenSubtileAndRightArrow
{
    _subTitle.hidden = NO;
    _rightArrow.hidden = NO;
}

@end
