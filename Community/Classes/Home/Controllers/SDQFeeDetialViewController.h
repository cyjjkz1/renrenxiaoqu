//
//  SDQFeeDetialViewController.h
//  Community_http
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, SDQFeeDetialType) {
    SDQFeeDetialShui,
    SDQFeeDetialDian,
    SDQFeeDetialQi,
    SDQFeeDetialWuye
};
@interface SDQFeeDetialViewController : BNBaseViewController

@property (nonatomic, assign) SDQFeeDetialType userType;
@end
