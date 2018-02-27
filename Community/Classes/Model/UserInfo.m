//
//  UserInfo.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

singleton_implementation(UserInfo);


- (BOOL)login
{
    NSString *str = [kUserDefaults objectForKey:@"login"];
    if (str && [str isEqualToString:@"YES"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setLogin:(BOOL)login
{
    if (login) {//登录成功
        [kUserDefaults setObject:@"YES" forKey:@"login"];
        
    }else{
        [kUserDefaults setObject:@"NO" forKey:@"login"];
    }
}
/*
- (void)setupTestData
{
    //假数据
    self.status = @"租客";
    self.phoneNumber = @"13688426514";
    self.userName = @"最帅的男人—刘春";
    self.sex = @"男";
    self.villige = @"香榭国际";
}
 */
- (void)setupDataWithDic:(NSDictionary *)dic
{
    NSString *type = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"type"]];
    if ([type isEqualToString:@"1"]) {
        self.status = @"业主";
    }else if([type isEqualToString:@"2"]){
        self.status = @"住户";
    }else{
        self.status = @"非小区人士";
    }
    
    self.phoneNumber = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"mobile"]];
    NSString *firstName = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"firstName"]];
    NSString *lastName = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"lastName"]];
    self.userName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
     NSInteger sex = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"gender"]].integerValue;
    self.sex = sex == 1 ? @"男" : @"女";
    self.villige = [[dic valueNotNullForKey:@"buildingName"] stringByAppendingString:[dic valueNotNullForKey:@"roomName"]];
    NSDictionary *photos = [dic valueNotNullForKey:@"photo"];
    if ([photos isKindOfClass:[NSDictionary class]]) {
         self.avatarUrl = [photos valueNotNullForKey:@"visitUrl"];
    }
    self.hasGetProfile = YES;
}


@end
