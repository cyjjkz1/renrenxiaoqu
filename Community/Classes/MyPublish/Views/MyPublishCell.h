//
//  MyPublishCell.h
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentInfoModel.h"

@protocol MyPublishCellDelegate <NSObject>

@optional
- (void)publishBtnAction:(UIButton *)button;

- (void)deleteBtnAction:(UIButton *)button;

@end

@interface MyPublishCell : UITableViewCell


- (void)setupCellWithDictionary:(RentInfoModel *)model index:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<MyPublishCellDelegate>delegate;


@end
