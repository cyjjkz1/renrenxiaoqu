//
//  WEGViewController.h
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, WEGVCUseType) {
    WEGVCUseTypeWaterElecGas,         //水电气
    WEGVCUseTypePropertyCost,         //物业费
};

@interface WEGViewController : BNBaseViewController

@property (nonatomic, assign) WEGVCUseType useType;

@end
