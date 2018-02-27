//
//  UserInfo.h
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject

singleton_interface(UserInfo);

@property (nonatomic, assign) BOOL hasGetProfile;

//是否登录
@property(assign, nonatomic) BOOL login;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *villige;

@property (nonatomic, copy) NSString *avatarUrl;

- (void)setupDataWithDic:(NSDictionary *)dic;

@end
