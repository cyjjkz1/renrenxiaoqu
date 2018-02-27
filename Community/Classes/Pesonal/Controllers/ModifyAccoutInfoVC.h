//
//  ModifyAccoutInfoVC.h
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

typedef enum : NSUInteger {
    ModifyAccoutInfoVCUseStyleChangeName,
    ModifyAccoutInfoVCUseStyleChangeVillige,
} ModifyAccoutInfoVCUseStyle;

@interface ModifyAccoutInfoVC : BNBaseViewController

@property (nonatomic, assign) ModifyAccoutInfoVCUseStyle useStyle;

@property (nonatomic, copy) void (^editFinishBlock)(NSString *text);

@end
