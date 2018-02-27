//
//  BNPayCenterHomeVC.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

//支付类型
typedef NS_ENUM(NSInteger, PayProjectType) {
 
    PayProjectTypeWater,            //水费
    PayProjectTypeEle,               //电费
    PayProjectTypeQi,
    PayProjectTypeWuYe               //物业费

};
//支付页面跳转类型
typedef NS_ENUM(NSInteger, PayVCJumpType) {
    PayVCJumpType_PayCompletedBackHomeVC,           //支付成功，返回主页面
};

typedef void (^ReturnBlock)(PayVCJumpType jumpType, id params);


#import "BNBaseViewController.h"
#import "SDQFeeDetialViewController.h"

@interface BNPayCenterHomeVC : BNBaseViewController

@property (copy, nonatomic) ReturnBlock returnBlock;
@property (assign, nonatomic) PayProjectType payProjectType;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *payType;


@end
