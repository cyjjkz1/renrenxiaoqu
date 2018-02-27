//
//  PublishType.m
//  Community
//
//  Created by mac1 on 16/9/7.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "PublishType.h"

@implementation PublishType

+ (PublishType *)changeDicToType:(NSDictionary *)dic
{
    PublishType *type = [[PublishType alloc] init];
    type.typeId = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"id"]];
    type.sortNo = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"sortNo"]];
    type.text = [dic valueNotNullForKey:@"text"];
    type.parentId = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"parentId"]];
    type.remark = [dic  valueNotNullForKey:@"remark"];
    
    return type;
}


@end
