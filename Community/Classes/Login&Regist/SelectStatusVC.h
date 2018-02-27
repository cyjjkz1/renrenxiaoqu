//
//  SelectStatusVC.h
//  Community
//
//  Created by mac1 on 2016/10/18.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseViewController.h"

@interface SelectStatusVC : BNBaseViewController

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;

//楼宇
@property (nonatomic, strong) NSArray *buildings;



@end
