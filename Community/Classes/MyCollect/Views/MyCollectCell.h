//
//  MyCollectCell.h
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentInfoModel.h"

@interface MyCollectCell : UITableViewCell


@property (nonatomic, strong) RentInfoModel *infoModel;

@property (nonatomic, assign) BOOL allSelected;

@end
