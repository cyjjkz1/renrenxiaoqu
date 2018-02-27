//
//  key.h
//  BLKApp
//
//  Created by ouge on 16/6/24.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface keyObject : NSObject

/** 设备id */
@property (nonatomic, strong) NSString *deviceId;

/** 开门密码 */
@property (nonatomic, strong) NSString *password;

/** 开门信号强度阀值 */
@property (nonatomic, assign)NSInteger  RSSI;

/** userId */
@property (nonatomic, assign)NSString*  userId;

@end
