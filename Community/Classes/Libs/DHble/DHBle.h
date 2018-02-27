//
//  DHBle.h
//  DHBle
//
//  Created by roryyang on 15/7/6.
//  Copyright (c) 2015年 dh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

/*
 define
 */

#define SERVICE_UUID     0xFEE7
#define CHAR_UUID        0xFEC6

/* API 函数执行结果 */
typedef NS_ENUM(NSInteger, DHBleErrorType) {
    DHBLE_ER_OK = 0,
    DHBLE_ER_NG,
    DHBLE_ER_SENDING, /* 数据正在发送中 */
    DHBLE_ER_NO_CONNECT, /* 设备未连接 */
    DHBLE_ER_DEVICE_ID, /* 设备ID错误 */
};

typedef NS_ENUM(NSInteger, DHBleTxPowerType) {
    TX_POWER_MINUS_23_DBM = 0,
    TX_POWER_MINUS_6_DBM,
    TX_POWER_0_DBM,
    TX_POWER_4_DBM
};

/* 设备结果返回状态 */
typedef NS_ENUM(NSInteger, DHBleResultType) {
    DHBLE_RESULT_SERVICE_NOT_FOUND = -1,
    METHOD_ERR_DEVICE_NOT_CONN = -2,
    METHOD_ERR_FROM_DEV = -3,
    METHOD_NOT_SUPPORT_BLE = -4,
    METHOD_BLE_NOT_ENABLED = -5,
    METHOD_OPERATE_TIMEOUT = -6,
    METHOD_PARAM_ERR = -8,
    METHOD_NOT_SCAN_DEV = -9,
    METHOD_SERVICE_NOT_FOUND = -10,
    DHBLE_RESULT_OK = 0,
    DHBLE_RESULT_NG,
    DHBLE_RESULT_SYSTEM_ERROR, /* 系统密码错误 */
    DHBLE_RESULT_LOCK_ID_ERROR, /* 锁ID不一致 */
    DHBLE_RESULT_PASSWORD_ERROR, /* 用户密码错误 */
    DHBLE_RESULT_TIMEOUT, /* 超时 */
    DHBLE_RESULT_NO_LOGIN, /* 没有登录 */
    DHBLE_RESULT_KEY_EXIST, /* 钥匙己经存在 */
    DHBLE_RESULT_KEY_FULL, /* 钥匙己满 */
    DHBLE_RESULT_KEY_EMPTY, /* 钥匙为空 */
};

/* 其它钥匙的类型 */
typedef NS_ENUM(NSInteger, DHBleOtherKeyType) {
    DHBLE_KEY_TYPE_CARD = 1, /* 卡片钥匙 */
    DHBLE_KEY_TYPE_PASSWORD, /* 密码钥匙 */
    DHBLE_KEY_TYPE_REMOTE, /* 遥控钥匙 */
};

/* 设备类型 */
typedef NS_ENUM(NSInteger, DHBleDeviceType) {
    TYPE_LOCK_HOME = 0, /*家用门锁*/
    TYPE_LOCK_HOTEL, /*酒店锁*/
    TYPE_LOCK_CARPORT, /*车位锁*/
    TYPe_LOCK_HANG, /*挂锁*/
    TYPE_LOCK_PASSIVE, /*无源电子锁*/
    TYPE_LOCK_ACCESS, /* 门禁 */
    TYPE_DEVICE_TOUCH_SWITCH = 10, /* 触摸开关 */
	TYPE_DEVICE_TOUCH_ADJUST_SWITCH, /* 触摸调光开关 */
    TYPE_DEVICE_WRGB, /* WRGB调光灯*/
    TYPE_DEVICE_LAB = 0x20, /* 电子标签 */
    TYPE_DEVICE_NULL = 0xff, /* 无效 */
};

/* */
typedef NS_ENUM(NSInteger, DHBleOpenCloseType) {
    TYPE_OPEN_LOCK = 0,
    TYPE_CLOSE_LOCK,
};


/* 家用锁的类型 */
typedef NS_ENUM(NSInteger, DHBleHomeKeyType) {
    TYPE_HOME_KEY_ALL = 0,
    TYPE_HOME_KEY_APP,  /* 手机APP */
    TYPE_HOME_KEY_PASSWORD,  /* 密码 */
    TYPE_HOME_KEY_CARD,  /* 卡片 */
    TYPE_HOME_KEY_FINGER_POINT, /* 指纹 */
};

@protocol DHBleDelegate<NSObject>

@optional




/**
 *  连接设备回调
 *
 *  @param result 设备结果返回状态
 */
- (void)connectDeviceCallBack:(DHBleResultType)result;


/**
 *  断开设备回调
 */
- (void)disconnectDeviceCallBack;


/**
 *  扫描设备设备回调
 *
 *  @param peripheral 设备对象
 *  @param level 信号强度
 */
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;


/**
 *  扫描设备设备超时回调
 *
 */
- (void)scanDeviceEndCallBack;


/**
 *  蓝牙初始化状态回调
 *
 *  @param state   状态值
 */
- (void)updateBluetoothStateCallBack:(CBCentralManagerState)state;


/**
 *  发现服务回调
 *
 *  @param result   扫描结果返回状态
 */
- (void)didDiscoverServicesCallBack:(DHBleResultType)result;


/**
 *  发现特征码务回调
 *
 *  @param result   扫描结果返回状态
 */
- (void)didDiscoverCharacteristicsCallBack:(DHBleResultType)result;


/**
 *  读取版本信息回调
 *
 *  @param pSw
 *  @param code
 *  @param flag
 *  @param pHw
 *  @param result   执行结果返回状态
 */
- (void)readVerInfoCallBack:(DHBleResultType)result hwInfo:(NSString*)pHw swInfo:(NSString*)pSw code:(UInt8)code configFlag:(UInt8)flag;


/**
 *  读取设备信息回调
 *
 *  @param deviceId 设备id
 *  @param status   配置状态
 *  @param result   执行结果返回状态
 */
- (void)readDeviceInfoCallBack:(DHBleResultType)result device:(UInt32)deviceId configStatus:(Byte)status;


/**
 *  配置设备信息回调
 *
 *  @param result   执行结果返回状态
 */
- (void)configDeviceCallBack:(DHBleResultType)result;


/**
 *  读取配置信息回调
 *
 *  @param advTime
 *  @param connectTime
 *  @param power
 *  @param actTime
 *  @param result   执行结果返回状态
 */
- (void)readConfigCallBack:(DHBleResultType)result activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime;
/**
 *  修改设备密码回调
 *
 *  @param result   执行结果返回状态
 */
- (void)modifyPasswordCallBack:(DHBleResultType)result;


/**
 *  修改设备名称回调
 *
 *  @param result   执行结果返回状态
 */
- (void)modifyNameCallBack:(DHBleResultType)result;

/**
 *  读取输入信息回调
 *
 *  @param status
 *  @param result   执行结果返回状态
 */
- (void)readInputCallBack:(DHBleResultType)result inputStatus:(Byte)status;


/**
 *  打开或者关闭设备回调
 *
 *  @param battery
 *  @param result   执行结果返回状态
 */
- (void)openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString*) devId;
- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery ;

/**
 *  重置设备回调
 *
 *  @param result   执行结果返回状态
 */
- (void)resetDevcieCallBack:(DHBleResultType)result;


/**
 *  读取时间回调
 *
 *  @param year   年
 *  @param month  月
 *  @param day    日
 *  @param hour   时
 *  @param minute 分
 *  @param second 秒
 *  @param result   执行结果返回状态
 */
- (void)readClockCallBack:(DHBleResultType)result year:(UInt16)year month:(Byte)month day:(Byte)day hour:(Byte)hour minute:(Byte)minute second:(Byte)second;


/**
 *  设置时间
 *
 *  @param result   执行结果返回状态
 */
- (void)setClockCallBack:(DHBleResultType)result;



// for ibeacon start
- (void)readIbeaconConfigCallBack:(DHBleResultType)result advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor;
- (void)setIbeaconConfigCallBack:(DHBleResultType)result;
- (void)setIbeaconUUIDCallBack:(DHBleResultType)result;
// for ibeacon end

// for config Wifi start
- (void)configWifiCallBack:(DHBleResultType)result;
- (void)configServerCallBack:(DHBleResultType)result;
- (void)configWifiHeartBeatCallBack:(DHBleResultType)result;
// for config Wifi end

// for home lock start
- (void)readPaswdAndCardKeyCallBack:(DHBleResultType)result totalKey:(UInt8)total currentKey:(UInt8)current userId:(UInt32)userId keyStatus:(UInt8)status;
- (void)addPaswdAndCardKeyCallBack:(DHBleResultType)result;
- (void)flashAddKeyCallBack:(DHBleResultType) result;
- (void)deletePaswdAndCardKeyCallBack:(DHBleResultType)result;
- (void)flashDeleteKeyCallBack:(DHBleResultType) result;

-(void)setDefaultDeviceCallBack:(DHBleResultType)result;
-(void)confDeviceIdAndUnitCallBack:(DHBleResultType)result;
-(void)readDeviceUnitCallBack:(DHBleResultType)result unitId:(UInt16) unitId buildingId:(UInt8)buildingId;
-(void)readCommunityUnitCallBack:(DHBleResultType)result buildingCount:(UInt8) buildingCount
                                      curIndex:(UInt8) curIndex buildingIds:(NSArray*) buildingIds;
-(void)confCommunityUnitCallBack:(DHBleResultType)result;
-(void)delCommunityUnitCallBack:(DHBleResultType)result;
-(void)readLockRecordCallBack:(DHBleResultType)result curIndex:(UInt32)curIndex
                   totalCount:(UInt32)totalCount recordList:(NSArray*)recordList;
-(void)delLockRecordCallBack:(DHBleResultType)result;
-(void)readGPRSAPNCallBack:(DHBleResultType)result apnStr:(NSString*)apnStr;
-(void)setGPRSAPNCallBack:(DHBleResultType)result;

// for home lock end

// for one key start
- (void)oneKeyOpenUserWithSignCallBack:(DHBleResultType)result;
// for one key end

// for ibeacon start
- (void)enterRegionCallBack;
- (void)exitRegionCallBack;
- (void)screenTurnOnCallBack;
// for ibeacon end

@end

@interface DHBle :NSObject<CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate>{
    
}
@property (nonatomic, strong)  id <DHBleDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion    *myBeacon;
@property (nonatomic) BOOL isPoweredOn;

#pragma mark - Methods for OneKey Interface

// for one key start
-(DHBleErrorType)oneKeyReadDeviceInfo:(CBPeripheral *)peripheral devicePassword:(NSString*)password;

-(DHBleErrorType)oneKeyReadVerInfo:(CBPeripheral *)peripheral;


-(DHBleErrorType)oneKeyConfigServer:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password port:(UInt16)port ip1:(UInt8)ip1 ip2:(UInt8)ip2 ip3:(UInt8)ip3 ip4:(UInt8)ip4 domain:(NSString *)pDomain;
-(DHBleErrorType)oneKeyConfigDevice:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime;
-(DHBleErrorType)oneKeyReadDeviceConfig:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password;


-(DHBleErrorType)oneKeyChangeDevPsw:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId oldPassword:(NSString*)password newPassword:(NSString*)newPaswd;

-(DHBleErrorType)oneKeyChangeDevName:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password deviceName:(char*)name nameLength:(UInt8)length;

-(DHBleErrorType)oneKeyOpenDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword :(UInt32)password openType:(DHBleOpenCloseType)type;
-(DHBleErrorType)oneKeyOpenDevice:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr :(NSString*)password openType:(DHBleOpenCloseType)type;

//open lock with deviceid and devicepsw in string type.
-(DHBleErrorType)oneKeyOpenDeviceII:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword :(NSString*)password openType:(DHBleOpenCloseType)type;

//open lock with keepOpenTime.
-(DHBleErrorType)oneKeyOpenDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword :(UInt32)password openType:(DHBleOpenCloseType)type keepOpenTime:(UInt16) keepLockOpenTime;
-(DHBleErrorType)oneKeyOpenDevice:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr :(NSString*)password openType:(DHBleOpenCloseType)type keepOpenTime:(UInt16) keepLockOpenTime;

-(DHBleErrorType)oneKeyOpenDeviceUserId:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password userId:(UInt32)userId;

-(DHBleErrorType)oneKeyOpenDeviceExt:(CBPeripheral *)peripheral userId:(UInt32)userId signature:(UInt8*)pSignature sigLength:(UInt8)length openType:(DHBleOpenCloseType)type;

-(DHBleErrorType)oneKeyOpenUserWithSign:(CBPeripheral *)peripheral  signData:(UInt8 *)pSign operateType:(DHBleOpenCloseType)type;

-(DHBleErrorType)oneKeyReadPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password keyIndex:(UInt8)index;
-(DHBleErrorType)oneKeyReadPaswdAndCardKey:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr:(NSString*)password keyIndex:(UInt8)index;

-(DHBleErrorType)oneKeyAddPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId KeyInfo:(UInt32)keyInfo activeYear:(UInt16)year activeMonth:(UInt8)month activeDay:(UInt8)day;
-(DHBleErrorType)oneKeyAddPaswdAndCardKey:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr:(NSString*)password type:(UInt8)passwordCard userId:(NSString*)userIdStr KeyInfo:(NSString*)keyInfoStr activeYear:(UInt16)year activeMonth:(UInt8)month activeDay:(UInt8)day;

-(DHBleErrorType)oneKeyAddPaswdAndCardKey:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr:(NSString*)password type:(UInt8)passwordCard userId:(NSString*)userIdStr KeyInfo:(NSString*)keyInfoStr activeTime:(NSDate*) validTime;

-(DHBleErrorType)oneKeyDeletePaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId;
-(DHBleErrorType)oneKeyDeletePaswdAndCardKey:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr:(NSString*)password type:(UInt8)passwordCard userId:(NSString*)userId;
//one key add key to flash
-(DHBleErrorType)oneKeyFlashAddKey:(CBPeripheral*)peripheral deviceNum:(NSString*) deviceId devicePassword:(NSString*) password type:(UInt8)keyType addKeyIdList:(NSArray*) keyIdList addActiveDateList:(NSArray*)activeDateList;
//one key delete key from flash
-(DHBleErrorType)oneKeyFlashDeleteKey:(CBPeripheral*)peripheral deviceNum:(NSString*) deviceId devicePassword:(NSString*) password type:(UInt8)keyType delKeyId:(NSString*) keyId;

-(DHBleErrorType)oneKeySetClock:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password setClockTime:(NSDate*)clockTime;

-(DHBleErrorType)oneKeyReadClock:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password;

-(void)oneKeyDisconnectDevice:(CBPeripheral*)perihperal;

-(DHBleErrorType) oneKeyServiceConfigDevice:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password  uploadRecordMask:(UInt32) uploadRead heartBeatT:(UInt32)heartBeatTime;

//Ibeacon
-(DHBleErrorType)oneKeySetIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password
                          advTime:(UInt32)advInt txPower:(UInt32)power main:(UInt32)major sub:(UInt32)minor;
-(DHBleErrorType)oneKeyReadIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password;

-(DHBleErrorType)oneKeySetIbeaconUUID:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password UUID:(UInt8 *)pUUID;
// for one key end

#pragma mark - Methods for controlling the BLKApp Sensor


+(DHBle*)shareInstance;


/**
 *  初始化蓝牙
 *
 */
-(void)bleInit; //controller setup

/**
 *  NSString to UInt32
 **/
- (UInt32 )stringToUInt32:(NSString *)string;
/**
 *  NSString to UInt32
 **/
- (NSString* )uInt32ToString:(UInt32)intValue;

/**
 *  扫描设备
 *
 *  @param timeout 超时时间
 */
-(int)scanDevice:(int)timeout;


/**
 *  扫描指定UUID的设备
 *
 *  @param timeout 超时时间
 */
-(int)scanDeviceWithUUID:(float)timeout;
-(int)scanDeviceWithUUID:(float)timeout serviceId:(NSString*) dhServiceUUID;
-(int)scanDeviceWithUUID:(float)timeout serviceIdList:(NSArray*) dhServiceUUIDList;


/**
 *  停止扫描
 *
 *  @return 0
 */
-(int)stopScanDevice;


/**
 *  连接设备
 *
 *  @param peripheral 连接对象
 */
-(void)connectDevice:(CBPeripheral *)peripheral;


/**
 *  断开设备连接
 *
 *  @param peripheral 断开对象
 */
-(void)disconnectDevice:(CBPeripheral *)peripheral;


/**
 *  读取版本信息
 *
 *  @param peripheral 读取对象
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)readVerInfo:(CBPeripheral *)peripheral;


/**
 *  读取设备信息
 *
 *  @param peripheral 读取对象
 *  @param password 设备密码
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)readDeviceInfo:(CBPeripheral *)peripheral devicePassword:(UInt32)password;


/**
 *  配置设备信息
 *
 *  @param peripheral 读取配置信息
 *  @param deviceId 设备ID
 *  @param password 设备密码
 *  @param advTime 
 *  @param connectTime
 *  @param power
 *  @param actTime
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)configDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime;


/**
 *  读取设备信息
 *
 *  @param peripheral 读取对象
 *  @param deviceId 设备ID
 *  @param password 设备密码
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)readConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;


/**
 *  修改密码
 *
 *  @param peripheral 读取对象
 *  @param deviceId 设备ID
 *  @param password 设备密码
 *  @param newPaswd 设备新密码
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)modifyPassword:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId oldPassword:(UInt32)password newPassword:(UInt32)newPaswd;

-(DHBleErrorType)modifyPasswordII:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId oldPassword:(NSString*)password newPassword:(NSString*)newPaswd;


/**
 *  修改设备密码
 *
 *  @param peripheral 读取对象
 *  @param deviceId 设备ID
 *  @param password 设备密码
 *  @param name 设备新密码
 *  @return DHBleErrorType 函数执行结果
 */
-(DHBleErrorType)modifyDeviceName:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password deviceName:(char*)name nameLength:(UInt8)length;
-(DHBleErrorType)modifyDeviceNameII:(CBPeripheral *)peripheral deviceNum:(NSString*)deviceId devicePassword:(NSString*)password deviceName:(char*)name nameLength:(UInt8)length;



-(DHBleErrorType)readInput:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;


-(DHBleErrorType)openDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;

//Open Lock and keep Lock open with keyyLockOpenTime.
-(DHBleErrorType)openDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password keepOpenTime:(UInt16) keepLockOpenTime;
-(DHBleErrorType)openDevice:(CBPeripheral *)peripheral deviceNumStr:(NSString*)deviceId devicePasswordStr:(NSString*)password keepOpenTime:(UInt16) keepLockOpenTime;

-(DHBleErrorType)closeDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;


-(DHBleErrorType)openDeviceUserId:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password userId:(UInt32)userId;


-(DHBleErrorType)openDeviceExt:(CBPeripheral *)peripheral userId:(UInt32)userId signature:(UInt8*)pSignature sigLength:(UInt8)length;

-(DHBleErrorType)closeDeviceExt:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId userId:(UInt32)userId signature:(UInt8*)pSignature;
-(DHBleErrorType)openLockWithUserSign:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;
-(DHBleErrorType)resetDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(UInt32)getDeviceId:(CBPeripheral *)peripheral;

/**
 *  获取设备ID(string)
 *
 *  @param peripheral 读取对象
 *  @return string类型的设备id
 */
-(NSString *)getDeviceIdForStringValue:(CBPeripheral *)peripheral;
-(UInt8)getDeviceType:(CBPeripheral *)peripheral;
-(NSString *)getDeviceName:(CBPeripheral *)peripheral;

-(DHBleErrorType)readClock:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;

-(DHBleErrorType)setClock:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password year:(UInt16)year month:(Byte)month day:(Byte)day hour:(Byte)hour minute:(Byte)minute second:(Byte)second;

-(NSString*)generateVisitePassword:(UInt32)deviceId devicePassword:(UInt32)password activeTime:(UInt16)activeTime;

//生成索引访客码 6位
-(NSString*)generateVisitCodeWithIds:(NSString*) deviceId
                           devicePsw:(NSString*)devicePsw validDate:(NSDate*)validDate communityCode:(UInt32)communityCode buildingCode:(UInt32)buildingCode visitIndex:(UInt32)visitIndex pswType:(UInt32)pswType;

//生成某天时间段访客码  6位
-(NSString*)generateVisitCodeWithDate:(NSString*) deviceId
                            devicePsw:(NSString*)devicePsw communityCode:(UInt32)communityCode
                         buildingCode:(UInt32)buildingCode valideData:(NSDate*)validDate startTime:(NSDate*)startTime endTime:(NSDate*)endTime;
//生成酒店访客码 8位
-(NSString*)generateVisitCodeWithDate:(NSString*) deviceId
                            devicePsw:(NSString*)devicePsw startDate:(NSDate*)startDate validDates:(UInt32)validDates needCover:(BOOL)needCover;
/* for Test */
//-(DHBleErrorType)getSignature:(UInt32)deviceId devicePassword:(UInt32)password signature:(UInt8 *)pBuf;

// for ibeacon start
//-(DHBleErrorType)readIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)setIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password
                          advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor;

-(DHBleErrorType)setIbeaconUUID:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password UUID:(UInt8 *)pUUID;
// for ibeacon end

// for config Wifi start
-(DHBleErrorType)configWifiSSID:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password SSID:(UInt8 *)pSSID SSIDLength:(UInt8)length;

-(DHBleErrorType)configWifiPassword:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password password:(UInt8 *)pPassword passwordLength:(UInt8)length;

-(DHBleErrorType)configServer:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password port:(UInt16)port ip1:(UInt8)ip1 ip2:(UInt8)ip2 ip3:(UInt8)ip3 ip4:(UInt8)ip4 domain:(UInt8 *)pDomain domainLength:(UInt8)length;

-(DHBleErrorType)configWifiHeartBeat:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password uploadRecord:(UInt8) uploadRecordMask heartBeat:(UInt8) heartBeatMask;
// for config Wifi End

-(DHBleErrorType)operateLockRemote:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;
-(DHBleErrorType)operateLockLocal:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;

// for home lock start
-(DHBleErrorType)readPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password keyIndex:(UInt8)index;
-(DHBleErrorType)addPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId KeyInfo:(UInt32)keyInfo activeYear:(UInt16)year activeMonth:(UInt8)month activeDay:(UInt8)day;
//add key to flash
-(DHBleErrorType)flashAddKey:(CBPeripheral*)peripheral deviceNum:(NSString*) deviceId devicePassword:(NSString*) password type:(UInt8)keyType addKeyIdList:(NSArray*) keyIdList addActiveDateList:(NSArray*)activeDateList;
//delete key from flash
-(DHBleErrorType)flashDeleteKey:(CBPeripheral*)peripheral deviceNum:(NSString*) deviceId devicePassword:(NSString*) password type:(UInt8)keyType delKeyId:(NSString*) keyId;

-(DHBleErrorType)deletePaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId;
// for home lock end


-(void)getSignData:(UInt8 *)pSign;

#pragma mark - nslog enable
-(void) enableNSLog:(BOOL)enabled;
// for ibeacon start
//-(void)initBeacon;
//-(void)startBeacon:(NSString *)UUID;
//-(void)stopBeacon;
// for ibeacon end
@end
