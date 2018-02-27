//
//  WEGChargeVC.h
//  Community
//
//  Created by mac1 on 2016/10/13.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, WEGChargeVCUseType) {
    WEGChargeVCUseTypeWaterEle,       //水电费
    WEGChargeVCUseTypeWuYe,         //物业费
};

@interface WEGChargeVC : BNBaseViewController

@property (nonatomic, assign) WEGChargeVCUseType chargeType;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *orderId;

@end
