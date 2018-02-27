//
//  RHTableViewCell.m
//  Community
//
//  Created by liuchun on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RHTableViewCell.h"

@interface RHTableViewCell ()

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *desLabel;
@property (weak, nonatomic) UILabel *roomNumber;
@property (weak, nonatomic) UILabel *roomArea;
@property (weak, nonatomic) UILabel *decoration;
@property (weak, nonatomic) UILabel *price;


@end

@implementation RHTableViewCell

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
    nameLabel.text = @"适合办公的高档电梯大户型新鲜出炉给你一个舒适的办公环境";
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    
    _desLabel = nameLabel;
    
    UILabel *roomNumber = [[UILabel alloc] init];
    roomNumber.frame = CGRectMake(nameLabel.x, nameLabel.maxY + 6 * BILI_WIDTH, 200 * BILI_WIDTH, 11 * BILI_WIDTH);
    roomNumber.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    roomNumber.text = @"一室一厅";
    roomNumber.textColor = tempColor;
    [self.contentView addSubview:roomNumber];
    _roomNumber = roomNumber;
    
    UILabel *roomArea = [[UILabel alloc] init];
    roomArea.frame = CGRectMake(roomNumber.x, roomNumber.maxY + 5 * BILI_WIDTH, 200 * BILI_WIDTH, 11 * BILI_WIDTH);
    roomArea.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    roomArea.text = @"90平";
    roomArea.textColor = tempColor;
    [self.contentView addSubview:roomArea];
    _roomArea = roomArea;
    
    UILabel *decoration = [UILabel new];
    decoration.frame = CGRectMake(SCREEN_WIDTH - 113*BILI_WIDTH, roomNumber.y, 100 * BILI_WIDTH, 11 * BILI_WIDTH);
    decoration.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    decoration.textAlignment = NSTextAlignmentRight;
    decoration.text = @"简装";
    decoration.textColor = tempColor;
    [self.contentView addSubview:decoration];
    _decoration = decoration;
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 113 * BILI_WIDTH, roomArea.y, 100 * BILI_WIDTH, 11 * BILI_WIDTH)];
    price.text = @"1700元";
    price.textAlignment = NSTextAlignmentRight;
    price.textColor = UIColorFromRGB(0xfe9801);
    price.font = [UIFont boldSystemFontOfSize:11 * BILI_WIDTH];
    [self.contentView addSubview:price];
    _price = price;
}

@end
