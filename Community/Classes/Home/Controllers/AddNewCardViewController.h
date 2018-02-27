//
//  AddNewCardViewController.h
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, AddNewCardVCUseType) {
    AddNewCardVCUseTypeAddWEG,         //水电气
    AddNewCardVCUseTypeAddNewUser,      //绑定新用户
};


@interface AddNewCardViewController : BNBaseViewController

@property (assign, nonatomic) AddNewCardVCUseType useType;
@end
