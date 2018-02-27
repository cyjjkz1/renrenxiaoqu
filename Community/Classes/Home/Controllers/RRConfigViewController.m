//
//  RRConfigViewController.m
//  Community
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "RRConfigViewController.h"
#import "DHBle.h"
#import "Macro.h"
#import "UIView+YSKit.h"
#import "OneKeyInterfaceViewController.h"


@interface RRConfigViewController ()<DHBleDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) DHBle *sensor;
@property (nonatomic, strong) NSMutableArray *peripheralViewControllerArray;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation RRConfigViewController
@synthesize sensor;
#pragma mark - 
#pragma mark GET
- (NSMutableArray *)peripheralViewControllerArray
{
    if(_peripheralViewControllerArray == nil){
        _peripheralViewControllerArray = [[NSMutableArray alloc] init];
        
    }
    return _peripheralViewControllerArray;
}
- (UITableView *)configTableView
{
    if (_configTableView == nil) {
        _configTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _configTableView.dataSource = self;
        _configTableView.delegate = self;
        _configTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _configTableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
        _configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _configTableView.separatorColor = [UIColor lightGrayColor];
        _configTableView.rowHeight = AdaptHeight(60);
        _configTableView.separatorInset = UIEdgeInsetsZero;
    }
    return _configTableView;
}

- (UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14*BILI_WIDTH]];
        [_rightBtn addTarget:self action:@selector(researchDevice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
#pragma mark - 
#pragma mark UIButton Action
- (void)researchDevice
{
    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [self.peripheralViewControllerArray removeAllObjects];
        [self.configTableView reloadData];
    }
    
    NSLog(@"now we are searching device...\n");
    
    [self.rightBtn setTitle:@"搜索中..." forState:UIControlStateNormal];
    self.rightBtn.enabled = YES;
    [SVProgressHUD showWithStatus:@"正在搜索设备..."];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [sensor scanDevice:15];
}

- (void)configSensor{
    sensor = [DHBle shareInstance];
    sensor.delegate = self;
}
- (void)scanTimer:(NSTimer *)timer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
    });

}
#pragma mark -
#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = @"门禁配置";
    [self.view addSubview:self.configTableView];
    [self.customNavigationBar addSubview:self.rightBtn];
    self.configTableView.frame = CGRectMake(0, self.customNavigationBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.customNavigationBar.bottom);
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - AdaptWidth(100), 0, AdaptWidth(95), 44);

    [self configSensor];
    
    [self researchDevice];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if(sensor.activePeripheral && CBPeripheralStateConnected == sensor.activePeripheral.state){
        [sensor disconnectDevice:sensor.activePeripheral];
    }
    CBPeripheral* peripheral = [self.peripheralViewControllerArray objectAtIndex:row];
    UInt8 devType = [sensor getDeviceType:peripheral ];
    if( devType == 0x20){
        NSLog(@"Can not operate this type of device.");
        //return;
    }
    sensor.activePeripheral = peripheral;
    
    OneKeyInterfaceViewController* onekeyController = [[OneKeyInterfaceViewController alloc]init];
    [self.navigationController pushViewController:onekeyController animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell
    NSUInteger row = [indexPath row];
    CBPeripheral *peripheral =[self.peripheralViewControllerArray objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [sensor getDeviceName:peripheral],
                                                               [sensor getDeviceIdForStringValue:peripheral]];
    //[sensor getDeviceName:peripheral];
    //cell.textLabel.text = peripheral.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:(NSString *), ...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


#pragma mark - BLKAppSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(NSNumber*)level
{
    //如果存在列表，保存最新的
    for (int i = 0; i < [self.peripheralViewControllerArray count]; i++) {
        CBPeripheral *p = [self.peripheralViewControllerArray objectAtIndex:i];
        if( [[sensor getDeviceIdForStringValue:peripheral] isEqualToString:[sensor getDeviceIdForStringValue:p]]){
            [self.peripheralViewControllerArray replaceObjectAtIndex:i withObject:p];
            [self.configTableView reloadData];
            return;
        }
    }
    [self.peripheralViewControllerArray addObject:peripheral];
    [self.configTableView reloadData];
    NSLog(@"******scanDeviceCallBack");
}

-(void) scanDeviceEndCallBack{
    NSLog(@"******scanDeviceEndCallBack");

}

- (void)connectDeviceCallBack:(DHBleResultType)result{
    
}

-(void) didDiscoverServicesCallBack:(DHBleResultType)result{
    
}

- (void)updateBluetoothStateCallBack:(CBCentralManagerState)state{
    switch (state) {
        case 0:
            /* 初始化中，请稍后…… */
            break;
        case 1:
            /* 设备不支持状态，过会请重试…… */
            break;
        case 2:
            /* 设备未授权状态，过会请重试…… */
            break;
        case 3:
            /* 设备未授权状态，过会请重试…… */
            break;
        case 4:
            /* 尚未打开蓝牙，请在设置中打开…… */
            break;
        case 5:
            /* 蓝牙已经成功开启，稍后…… */
            
            break;
        default:
            break;
    }
}

-(void) didDiscoverCharacteristicsCallBack:(DHBleResultType)result{
    
}

-(void)disconnectDeviceCallBack
{
    
}




@end
