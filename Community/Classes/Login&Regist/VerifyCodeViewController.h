//
//  VerifyCodeViewController.h
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, VerifyCodeViewControllerUserStyle) {
    VerifyCodeViewControllerUserStyleSettingPsw, //设置密码
    VerifyCodeViewControllerUserStyleModifyPsw,  //忘记密码
};

@interface VerifyCodeViewController : BNBaseViewController

@property (nonatomic, copy) NSString *mobileStr;
@property (nonatomic, assign) VerifyCodeViewControllerUserStyle useStyle;

@end
