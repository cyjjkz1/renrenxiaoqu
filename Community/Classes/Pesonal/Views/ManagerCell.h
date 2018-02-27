//
//  ManagerCell.h
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ManagerCellDelegate <NSObject>

@optional
- (void)callBtnAcion:(UIButton *)button;

@end

@interface ManagerCell : UITableViewCell

- (void)setupCellWithDic:(NSDictionary *)dic index:(NSIndexPath *)index;

@property (nonatomic, weak) id <ManagerCellDelegate>delegate;

@end
