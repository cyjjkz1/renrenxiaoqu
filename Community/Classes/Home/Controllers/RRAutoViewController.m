//
//  RRAutoViewController.m
//  Community
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "RRAutoViewController.h"
#import "OneKeyApi.h"
#import "Macro.h"
#import "UIView+YSKit.h"
@interface RRAutoViewController ()<YYlockApiDelegate>

@property (strong, nonatomic) UIButton *openButton;

@end

@implementation RRAutoViewController

- (UIButton *)openButton{
    if (_openButton == nil) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.backgroundColor = UIColorFromRGB(0x399CFE);
        [_openButton setTitle:@"一键开门" forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_openButton.titleLabel setFont:[UIFont systemFontOfSize:14*BILI_WIDTH]];
        [_openButton addTarget:self action:@selector(oneKeyPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"自动开门";
    [self.view addSubview:self.openButton];
    self.openButton.frame = CGRectMake(kScreenWidth/4.0, (kScreenHeight - kScreenWidth/2.0)/2.0, kScreenWidth/2.0, kScreenWidth/2.0);
    self.openButton.layer.cornerRadius = self.openButton.width/2.0;
    self.openButton.layer.masksToBounds = YES;
    

    //注册开门设备信息
    [self registerYYlock];
    
    //设置执行回调代理
    [OneKeyApi shareInstance].delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

//注册YYlock
-(void)registerYYlock
{
    keyObject *keyModel = [[keyObject alloc]init];
    keyModel.deviceId = @"03040533";
    keyModel.password = @"12345678";
    keyModel.RSSI = -45;
    
    keyObject *keyModel2 = [[keyObject alloc]init];
    keyModel2.deviceId = @"55BC4AE9";
    keyModel2.password = @"12345678";
    keyModel2.RSSI = -90;
    
    keyObject *keyModel3 = [[keyObject alloc]init];
    keyModel3.deviceId = @"C2B88711";
    keyModel3.password = @"68549632";
    keyModel3.RSSI = -90;
    
    NSArray *keyArray = [NSArray arrayWithObjects:keyModel,keyModel2,keyModel3,nil];
    
    //获取单例
    OneKeyApi *yylockApi = [OneKeyApi shareInstance];
    
    //默认开启ibeanon
    yylockApi.isSuppertIbeacon =  YES;
    
    //初始化设备信息
    float devVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    [yylockApi registerDeviceWithMode:LOCK_MODE_AUTO andDeviceInfos:keyArray andNeedCmpRssi:YES supportBeacon:YES deviceVersion:devVersion];
}

//一键开门
- (void)oneKeyPress:(id)sender {
    //with default keep lock open time
    [[OneKeyApi shareInstance] oneKeyOpenDevice:nil andDevicePassword:nil];
    //with custome keep lock open time(in seconds)
    //UInt8 keepOpenTime = 10;
    //[[OneKeyApi shareInstance] oneKeyOpenDevice:nil andDevicePassword:nil keepOpenTime:keepOpenTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-YYlockApiDelegate

//扫描设备回调
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level
{
    //    NSLog(@"%s",__FUNCTION__);
    
}

//扫描设备超时回调
- (void)scanDeviceEndCallBack
{
    NSLog(@"%s",__FUNCTION__);
    
}

//断开连接回调
- (void)disconnectDeviceCallBack
{
    NSLog(@"%s",__FUNCTION__);
    
}

//蓝牙状态回调
- (void)updateBluetoothStateCallBack:(CBCentralManagerState)state
{
    NSLog(@"%s",__FUNCTION__);
}


//打开或者关闭设备回调
- (void)openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString *)devId
{
    NSLog(@"%s",__FUNCTION__);
    
}

@end
