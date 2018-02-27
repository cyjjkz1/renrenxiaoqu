//
//  WEGCell.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "WEGCell.h"

@interface WEGCell ()

@property (nonatomic, weak) UIView *whiteBGView;
@property (nonatomic, weak) UIImageView *theImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation WEGCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}

- (void)createCellSubViews
{
    UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 101*BILI_WIDTH)];
    cellContentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.contentView addSubview:cellContentView];

    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 13 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, 88.5*BILI_WIDTH)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.cornerRadius = 4 * BILI_WIDTH;
    [cellContentView addSubview:whiteBGView];
    _whiteBGView = whiteBGView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 * BILI_WIDTH, 19 * BILI_WIDTH, 58 * BILI_WIDTH, 48 * BILI_WIDTH)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [whiteBGView addSubview:imageView];
    _theImageView = imageView;
    
    UIColor *tempColor = UIColorFromRGB(0xa8a8a8);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 15 * BILI_WIDTH, 25 * BILI_WIDTH, 183 * BILI_WIDTH, 13 * BILI_WIDTH)];
    nameLabel.text = @"香榭国际——水卡";
    nameLabel.textColor = tempColor;
    nameLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 15 * BILI_WIDTH, nameLabel.maxY + 13*BILI_WIDTH, 200 * BILI_WIDTH, 13 * BILI_WIDTH)];
    numLabel.text = @"卡号:987654321";
    numLabel.textColor = tempColor;
    numLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:numLabel];
    _numLabel = numLabel;
 
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _whiteBGView.backgroundColor = highlighted ? [UIColor cyanColor] : [UIColor whiteColor];
}

@end
