//
//  SettingCell.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()

@property(nonatomic, weak) UILabel *cTitleLabel;
@end


@implementation SettingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 200, 50)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    self.cTitleLabel = label;
    [self.contentView addSubview:label];
}

- (void)showWithTitle:(NSString *) title
{
    self.cTitleLabel.text = title;
}
@end
