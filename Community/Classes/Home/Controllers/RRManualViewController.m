//
//  RRManualViewController.m
//  Community
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "RRManualViewController.h"
#import "OneKeyApi.h"
#import "DHBle.h"
#import "Macro.h"
#import "UIView+YSKit.h"
@interface RRManualViewController ()<YYlockApiDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *deviceTableView;
/** 设备id */
@property (nonatomic, retain) NSMutableArray *peripheralArray;
@property (nonatomic, assign) BOOL isFirstLauch;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation RRManualViewController
- (UITableView *)configTableView
{
    if (_deviceTableView == nil) {
        _deviceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceTableView.dataSource = self;
        _deviceTableView.delegate = self;
        _deviceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _deviceTableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
        _deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _deviceTableView.separatorColor = [UIColor lightGrayColor];
        _deviceTableView.rowHeight = AdaptHeight(60);
        _deviceTableView.separatorInset = UIEdgeInsetsZero;
    }
    return _deviceTableView;
}

- (UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14*BILI_WIDTH]];
        [_rightBtn addTarget:self action:@selector(reScanDevice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"手动开门";
    [self.view addSubview:self.configTableView];
    [self.customNavigationBar addSubview:self.rightBtn];
    self.configTableView.frame = CGRectMake(0, self.customNavigationBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.customNavigationBar.bottom);
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - AdaptWidth(80), 0, AdaptWidth(75), 44);
    
    
    
    _isFirstLauch  = true;
    //注册开门设备信息
    
    [self registerYYlock];
    
    //初始化蓝牙列表数组
    self.peripheralArray = [NSMutableArray array];
    
    //设置执行回调代理
    [OneKeyApi shareInstance].delegate = self;
}

-(void) viewDidAppear:(BOOL)animated{
    //启动扫描蓝牙设备
    [super viewDidAppear:animated];
    [OneKeyApi shareInstance].delegate = self;
    [self.peripheralArray removeAllObjects];
    [self.deviceTableView reloadData];
    [SVProgressHUD showWithStatus:@"正在搜索设备"];
    [[OneKeyApi shareInstance] scanDeviceWithUUID:10.0f];
    
}

//注册YYlock
-(void)registerYYlock
{
    keyObject *keyModel = [[keyObject alloc]init];
    keyModel.deviceId = @"F36862EA";
    keyModel.password = @"12345678";
    keyModel.RSSI = -80;
    
    keyObject *keyModel2 = [[keyObject alloc]init];
    keyModel2.deviceId = @"F3690036";
    keyModel2.password = @"12345678";
    keyModel2.RSSI = -90;
    
    keyObject *keyModel3 = [[keyObject alloc]init];
    keyModel3.deviceId = @"F3690036";
    keyModel3.password = @"68549632";
    keyModel3.RSSI = -90;
    
    NSArray *keyArray = [NSArray arrayWithObjects:keyModel,keyModel2,keyModel3,nil];
    
    //NSArray *keyArray = @[keyModel,keyModel2];
    
    //获取单例
    OneKeyApi *yylockApi = [OneKeyApi shareInstance];
    
    //初始化设备信息
    float devVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    [yylockApi registerDeviceWithMode:LOCK_MODE_MANUL andDeviceInfos:keyArray andNeedCmpRssi:NO supportBeacon:NO deviceVersion:devVersion];
}

- (void)reScanDevice:(id)sender{
    [OneKeyApi shareInstance].delegate = self;
    [self.peripheralArray removeAllObjects];
    [self.deviceTableView reloadData];
    [[OneKeyApi shareInstance] scanDeviceWithUUID:10.0f];
    [SVProgressHUD showWithStatus:@"正在搜索设备..."];
}

#pragma mark-YYlockApiDelegate

//扫描设备回调
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level
{
    int i =0;
    for (CBPeripheral *peripher in [self peripheralArray]) {
        DHBle * dhBleInstance = [DHBle shareInstance];
        NSString *deviceId = [dhBleInstance getDeviceIdForStringValue:peripher];
        if( [deviceId isEqualToString:[dhBleInstance getDeviceIdForStringValue:peripheral]]){
            [self.peripheralArray replaceObjectAtIndex:i withObject:peripher];
            return;
        }
        i++;
    }
    [self.peripheralArray addObject:peripheral];
    [self.deviceTableView reloadData];
}

//扫描设备超时回调
- (void)scanDeviceEndCallBack
{
    NSLog(@"%s",__FUNCTION__);
    [SVProgressHUD dismiss];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.peripheralArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myProfileInfoTableViewCellIdentifier = @"myProfileInfoTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myProfileInfoTableViewCellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myProfileInfoTableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CBPeripheral *peripheral = self.peripheralArray[indexPath.row];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

-(void)refreshTableviewAction:(UIRefreshControl *)refreshs
{
    NSLog(@"======");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral *peripheral = self.peripheralArray[indexPath.row];
    
    if(_isFirstLauch){
        OneKeyApi* yylockApi = [OneKeyApi shareInstance];
        
        float devVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        [yylockApi registerDeviceWithMode:LOCK_MODE_MANUL andDeviceInfos:nil andNeedCmpRssi:NO supportBeacon:NO deviceVersion:devVersion];
        _isFirstLauch = false;
    }
    
    //with default keep lock open time
    [[OneKeyApi shareInstance] oneKeyOpenDevice:peripheral andDevicePassword:@"12345678"];
    //with custom keep lock open time
    //[[OneKeyApi shareInstance] oneKeyOpenDeviceUserId:peripheral andDevicePassword:@"12345678" userId:@"12345678"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery{
    
}

-(void) openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString *)devId{
    NSLog(@"******** openCloseDeviceIICallBack: %ld deviceId: %@ ",(long)result,devId);
}

-(void) disconnectDeviceCallBack{
    
    NSLog(@"******* disconnectDeviceCallBack");
}

@end
