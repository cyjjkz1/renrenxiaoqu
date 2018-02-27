//
//  ModifyAddressVC.h
//  Community
//
//  Created by mac1 on 2016/11/13.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

@interface ModifyAddressVC : BNBaseViewController

//楼宇
@property (nonatomic, strong) NSArray *buildings;

@property (nonatomic, copy) void (^editFinishBlock)(NSString *buildingName, NSString *roomNumber);

@end
