//
//  BNPublishNextVC.h
//  Community
//
//  Created by mac1 on 16/8/25.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"
#import "PublishType.h"

typedef NS_ENUM(NSInteger, BNPublishNextVCUseType) {
    BNPublishNextVCUseType_sale_house,         //房屋出售
    BNPublishNextVCUseType_rent_house,         //房屋出租
    
    BNPublishNextVCUseType_sale_car,           //车位出售
    BNPublishNextVCUseType_rent_car,           //车位出租
    
    PubForAskVCUseType_sale_house,            //房屋求购
    PubForAskVCUseType_rent_house,            //房屋求租
    
    PubForAskVCUseType_sale_car,              //车位求购
    PubForAskVCUseType_rent_car               //车位求租
};


@interface BNPublishNextVC : BNBaseViewController

@property (nonatomic, assign) BNPublishNextVCUseType useType;
@property (nonatomic, strong) PublishType *type;


@property (nonatomic, strong) NSArray *houseTypes;
@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NSArray *decorationTypes;
@property (nonatomic, strong) NSArray *payTypes;



@end
