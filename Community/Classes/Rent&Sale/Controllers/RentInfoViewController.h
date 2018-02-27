//
//  RentInfoViewController.h
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RentInfoModel.h"
#import "BNShareBaseViewController.h"

@interface RentInfoViewController : BNShareBaseViewController

@property (nonatomic, strong) RentInfoModel *rentInfo;
@property (strong, nonatomic) NSString *navTitle;

@end
