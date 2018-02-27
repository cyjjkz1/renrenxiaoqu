//
//  RenterInfoSecondCell.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RenterInfoSecondCell.h"

@implementation RenterInfoSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}
- (void)createCellSubViews
{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(28*BILI_WIDTH, 15 * BILI_WIDTH, 150, 13*BILI_WIDTH)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    title.text = @"租金";
    [self.contentView addSubview:title];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0, title.y , SCREEN_WIDTH - 13 * BILI_WIDTH, title.h)];
    detail.textColor = UIColor_Gray_Text;
    detail.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    detail.text = @"600元/月";
    detail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:detail];
    
}
@end
