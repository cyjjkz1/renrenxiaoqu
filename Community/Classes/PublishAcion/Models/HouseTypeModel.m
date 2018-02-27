//
//  HouseTypeModel.m
//  Community
//
//  Created by mac1 on 16/9/7.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "HouseTypeModel.h"

@implementation HouseTypeModel


+ (HouseTypeModel *)changeDicToModel:(NSDictionary *)dic{
    HouseTypeModel *model = [[HouseTypeModel alloc] init];
    
    model.modelId = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"id"]];
    model.text = [dic valueNotNullForKey:@"text"];
    model.parentId = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"parentId"]];
    model.sortNo = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"sortNo"]];
    model.remark = [dic valueNotNullForKey:@"remark"];
    return model;
}
//id : 4,
//text : 标间,
//parentId : 3,
//sortNo : 1,
//remark : 标间

@end
