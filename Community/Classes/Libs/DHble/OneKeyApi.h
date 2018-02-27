//
//  YYlockApi.h
//  BLKApp
//
//  Created by ouge on 16/6/24.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "keyObject.h"
#import "DHBle.h"


/*! @brief 开门方式
 *
 */
typedef NS_ENUM(NSInteger, LockType) {
    LOCK_MODE_AUTO      = 1,    /**< 在ibeacon自动扫描开锁，断开连接后会进入扫描状态。    */
    LOCK_MODE_MANUL         /**< 自定义一键开锁   */
};

@protocol YYlockApiDelegate <NSObject>

@optional


/**
 *  扫描设备回调
 *
 *  @param peripheral 设备对象
 *  @param level      信号值
 */
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level;

/**
 *  扫描设备超时回调
 */
- (void)scanDeviceEndCallBack;

/**
 *  断开连接回调
 */
- (void)disconnectDeviceCallBack;

/**
 *  蓝牙状态回调
 *
 *  @param state 状态值
 */
- (void)updateBluetoothStateCallBack:(CBCentralManagerState)state;


/**
 *  开门回调
 *
 *  @param battery
 *  @param result   执行结果返回状态
 */
- (void)openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString*) devId;

- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery;

@end

@interface OneKeyApi : NSObject



/** 代理对象 */
@property (nonatomic,weak)id<YYlockApiDelegate>delegate;


/** 是否在Ibeance范围内 */
@property (nonatomic) BOOL isIbeacon;

/** 是否支持Ibeacon，默认支持 */
@property (nonatomic) BOOL isSuppertIbeacon;



/**
 *  获取单例
 *
 *  @return 单例
 */
+ (instancetype)shareInstance;



/**
 *  注册开门设备
 *
 *  @param lockMode    开锁模式
 *  @param keyObject        钥匙数组
 *  @param needCmpRssi 是否比较信号强度
 *
 */
- (void) registerDeviceWithMode:(LockType)lockMode
       andDeviceInfos:(NSArray *)keys
                 andNeedCmpRssi:(BOOL)needCmpRssi supportBeacon:(BOOL)isSuppertIbeacon  deviceVersion:(float)devVersion;

/**
 *  注册开门设备
 *
 *  @param lockMode    开锁模式
 *  @param keyObject        钥匙数组
 *  @param needCmpRssi 是否比较信号强度
 *  @param userId 是否比较信号强度
 *
 */
- (void) registerDeviceWithMode:(LockType)lockMode
                 andDeviceInfos:(NSArray *)keys
                 andNeedCmpRssi:(BOOL)needCmpRssi supportBeacon:(BOOL)isSuppertIbeacon  deviceVersion:(float)devVersion userId:(NSString*)userId;


/**
 *  前提是auto模式一键开门，并已预置参数
 *
 */
-(void)autoOneKeyOpenDevice;

/**
 *  一键开门
 *
 *  @param peripheral     需要开门的设备对象
 *  @param devicePassword 设备密码
 */
-(void)oneKeyOpenDevice:(CBPeripheral *)peripheral andDevicePassword:(NSString *)devicePassword;

-(void)oneKeyOpenDevice:(CBPeripheral *)peripheral andDevicePassword:(NSString *)devicePassword keepOpenTime:(UInt16)keepLockOpenTime;

-(void)oneKeyOpenDeviceUserId:(CBPeripheral *)peripheral andDevicePassword:(NSString *)devicePassword userId:(NSString *)userId;



/**
 *  扫描指定UUID的设备
 *
 *  @param timeout 超时时间
 */
-(void)scanDeviceWithUUID:(float)timeout;

@end



