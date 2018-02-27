//
//  DropViewCell.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "DropViewCell.h"

@interface DropViewCell ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation DropViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.layer.borderColor = UIColor_GrayLine.CGColor;
        self.contentView.layer.borderWidth = 0.5;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/3.0 - 10, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [self.contentView addSubview:label];
        _label = label;
        
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
}

@end
