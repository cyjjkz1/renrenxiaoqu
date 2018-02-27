//
//  HomeViewController.m
//  Community
//
//  Created by liuchun on 16/6/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomButton.h"
#import "JCTopic.h"
#import "HomeCell.h"
#import "WEGViewController.h"
#import "AccessControlVC.h"
#import "RentInfoModel.h"
#import "BNBaseWebViewController.h"
#import "KeychainItemWrapper.h"
#import "BNRSDetailVC.h"
#import "MJRefresh.h"
#import "RRAccessViewController.h"
#import "cc_macro.h"
#import "SDQViewController.h"
#import "SDQFeeDetialViewController.h"
#import "BNPayCenterHomeVC.h"
#import "OneKeyApi.h"
#import "HouseRentSaleCell.h"
@interface HomeViewController ()<JCTopicDelegate, UITableViewDelegate, UITableViewDataSource, YYlockApiDelegate, UIAlertViewDelegate>
@property (nonatomic, weak) JCTopic *jcTopicView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, strong) NSMutableArray *peripheralArray;
@end

@implementation HomeViewController

static NSString *const homeCellID = @"homeCellID";
static NSString *const kLDBannerCache = @"kLDBannerCache";
static NSString  *const size = @"10";

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"首页";
    self.backButton.hidden = YES;
    self.page = 0;
    [self setupLoadedView];
    [self getBannerData];
    [self getRecentInfo];
    [self autoLogin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentData) name:kNotification_UpdateCurrentPageData object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_UpdateCurrentPageData object:nil];
}
- (void)updateCurrentData
{
    [self getBannerData];
    [self getRecentInfo];
    [self autoLogin];
}
- (void)setupLoadedView
{
    self.telManagerBtn.hidden = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 212 * BILI_WIDTH)];
    headerView.backgroundColor = UIColor_Gray_BG;
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100 * BILI_WIDTH)];
    whiteBGView.backgroundColor = UIColorFromRGB(0x0080ff);
    [headerView addSubview:whiteBGView];
    
    //3个按钮
    NSArray *buttonTitle = @[@"门禁",@"水电气",@"物业费",@"物管"];
    NSArray *imageNames = @[@"icon_home_menjing",@"icon_shuidianqi",@"icon_wuyefee",@"icon_home_wuguan"];
    CGFloat buttonWidth = SCREEN_WIDTH/4.0;
    for (int i = 0; i < 4; i++) {
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:20 * BILI_WIDTH imgHeight:40*NEW_BILI textBottomY:20 * BILI_WIDTH];
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, whiteBGView.h);
        button.tag = 100 + i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(smallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBGView addSubview:button];
    }
    
    CGFloat jcTopicViewHeight =  100 * BILI_WIDTH;
    JCTopic *jcTopicView = [[JCTopic alloc] initWithFrame:CGRectMake(0, whiteBGView.maxY + 6*BILI_WIDTH, SCREEN_WIDTH,jcTopicViewHeight)];
    jcTopicView.JCdelegate = self;
    jcTopicView.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, jcTopicView.maxY-25, 60,30)];
    jcTopicView.pageControl.hidesForSinglePage = YES;
    jcTopicView.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xff9700);
    [headerView addSubview:jcTopicView];
    _jcTopicView = jcTopicView;
//    headerView.x
    NSArray *ads = [[NSUserDefaults standardUserDefaults] objectForKey:kLDBannerCache];
    if (ads.count == 0 || ads == nil) {
        ads = @[@{@"pic": [UIImage imageNamed:@"banner_default"], @"isLoc": @YES, @"url": @""}];
    }
    [self reloadJCTopicView:ads];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight - TabbarHeight)];
    tableView.rowHeight = 92.5 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    _tableView = tableView;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
//    HouseRentSaleCell
    [tableView registerClass:[HouseRentSaleCell class] forCellReuseIdentifier:homeCellID];
    
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


#pragma  mark -buttonAction

- (void)navigationRightBtnAction:(UIButton *)btn
{
//    BNPayCenterHomeVC *payVC = [[BNPayCenterHomeVC alloc] init];
//    payVC.payProjectType = PayProjectTypeWaterEle;
//    payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
//        //        returnBlock(jumpType, params);
//    };
//    payVC.amount = @"1000";
//    payVC.orderId = @"23452345";
//
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
//    nav.navigationBarHidden = YES;
//    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    nav.view.backgroundColor = [UIColor clearColor];
//    [self presentViewController:payVC animated:NO completion:nil];
    
//    return;
    if ([[UserInfo sharedUserInfo].status isEqualToString:@"非小区人士"]) {
        [SVProgressHUD showErrorWithStatus:@"非小区人士无法使用SOS功能"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定呼叫SOS服务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    if(buttonIndex == 0){
        
    }else if(buttonIndex == 1){
        [self callSosServiceApi];
    }else{
        
    }
}
- (void)callSosServiceApi{
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi sosToWuYeWithPhone:[UserInfo sharedUserInfo].phoneNumber
                           success:^(NSDictionary *successData) {
                               if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                   [SVProgressHUD showSuccessWithStatus:successData[@"result_message"]];
                                   //请求成功处理
//                                   [NSDictionary *retData = successData[@"data"];]
                                   
                               }else{
                                   [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                               }
                           }
                            failed:^(NSError *error) {
                                [SVProgressHUD showErrorWithStatus:@"稍后重试"];
                            }];
}

- (void)smallButtonAction:(CustomButton *)button
{
    switch (button.tag) {
        case 100://门禁
        {
            if ([[UserInfo sharedUserInfo].status isEqualToString:@"非小区人士"]) {
                [SVProgressHUD showErrorWithStatus:@"非小区人士无法使用打开门禁功能"];
                return;
            }
            [self registerYYlock];
            [OneKeyApi shareInstance].delegate = self;
            //初始化蓝牙列表数组
            self.peripheralArray = [NSMutableArray array];
            //设置执行回调代理
            
            OneKeyApi* yylockApi = [OneKeyApi shareInstance];
            
            float devVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
            
            [yylockApi registerDeviceWithMode:LOCK_MODE_MANUL andDeviceInfos:nil andNeedCmpRssi:NO supportBeacon:NO deviceVersion:devVersion];
            
            [OneKeyApi shareInstance].delegate = self;
            [self.peripheralArray removeAllObjects];
            [SVProgressHUD showWithStatus:@"正在搜索设备"];
            [[OneKeyApi shareInstance] scanDeviceWithUUID:10.0f];
        }
            break;
        case 101://水电气
        {
            if ([[UserInfo sharedUserInfo].status isEqualToString:@"非小区人士"] ||
                [[UserInfo sharedUserInfo].status isEqualToString:@"住户"] ) {
                [SVProgressHUD showErrorWithStatus:@"交纳水电气费功能目前只对业主开放"];
                return;
            }
            SDQViewController *vc = [[SDQViewController alloc] init];
            [self pushViewController:vc animated:YES];
        }
            break;
        case 102://物业费
        {
            if ([[UserInfo sharedUserInfo].status isEqualToString:@"非小区人士"] ||
                [[UserInfo sharedUserInfo].status isEqualToString:@"住户"] ) {
                [SVProgressHUD showErrorWithStatus:@"交纳物业费功能目前只对业主开放"];
                return;
            }
            SDQFeeDetialViewController *vc = [[SDQFeeDetialViewController alloc] init];
            vc.userType = SDQFeeDetialWuye;
            [self pushViewController:vc animated:YES];
        }
            break;
        case 103://物管
        {
            if ([[UserInfo sharedUserInfo].status isEqualToString:@"非小区人士"]) {
                [SVProgressHUD showErrorWithStatus:@"联系物管功能目前只对业主开放"];
                return;
            }
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"02886985158"];
            // NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        default:
            break;
    }
}

-(void)didClick:(id)data
{
    BNBaseWebViewController *webVc = [[BNBaseWebViewController alloc] init];
    webVc.urlString = data[@"url"];
    [self pushViewController:webVc animated:YES];
}

- (UIImage *)createScreenShot
{
    //开启上下文,第一个参数是UIGraphicsGetImageFromCurrentImageContext得到的image的size
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight), YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //上下文向上平移NAVIGATION_STATUSBAR_HEIGHT （重要）
    CGContextTranslateCTM(context, 0, -NaviHeight);
    //直接截取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma  mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseRentSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID forIndexPath:indexPath];
    [cell handleCellWithInfo:self.datas[indexPath.row]];
    return cell;
}


#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BNRSDetailVC *detailVC = [[BNRSDetailVC alloc] init];
    detailVC.model = self.datas[indexPath.row];
    [self pushViewController:detailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35 * BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, whiteView.h - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16 * BILI_WIDTH, 0, SCREEN_WIDTH, 34 * BILI_WIDTH)];
    label.text = @"附近";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:12 * BILI_WIDTH];
    [whiteView addSubview:label];
    
    
    return  whiteView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35 * BILI_WIDTH;
}


//获取banner
- (void)getBannerData
{
    __weak typeof(self) weakSelf = self;
    [RequestApi getBannerDataSuccess:^(NSDictionary *successData) {
        NSLog(@"获取banner--->>>> %@",successData);
        if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            
            NSArray *data = successData[kRequestReturnData];
            NSMutableArray *ads = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                NSString *imageURL = dic[@"visitUrl"];
                NSString *linkURL = dic[@"outLink"];
                [ads addObject:@{@"pic": imageURL, @"isLoc": @NO, @"url": linkURL}];
            }
            
            [weakSelf reloadJCTopicView:ads];
            
        }else{
            NSString *retMsg = successData[kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failed:^(NSError *error) {
        
    }];
}

//刷新banner
- (void)reloadJCTopicView:(NSArray *)tempImgArray
{
//    CGSize pageControlSize = [self.jcTopicView.pageControl sizeForNumberOfPages:tempImgArray.count];
//    self.jcTopicView.pageControl.frame = CGRectMake((SCREEN_WIDTH-pageControlSize.width)/2, self.jcTopicView.pageControl.frame.origin.y, pageControlSize.width,40);
    
    _jcTopicView.pics = tempImgArray;
    [_jcTopicView upDate];
}

//获取附近 定位等 TODO
- (void)getRecentInfo
{
    __weak typeof(self) weakSelf = self;
    [RequestApi getInfoListWithArticleType:nil
                                 titleType:nil
                                    userId:nil
                                     index:[NSString stringWithFormat:@"%ld",(long)self.page]
                                      size:size
                                   success:^(NSDictionary *successData) {
                                       NSLog(@"附近--->>> %@",successData);
                                       
                                       if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                           NSArray *data = [successData valueNotNullForKey:kRequestReturnData];
                                           
                                           if(self.page == 0){
                                               [self.datas removeAllObjects];
                                               self.lastCount = 0;
                                           }
                                           
                                           for (int i = 0; i < data.count; i ++) {
                                               RentInfoModel *model = [RentInfoModel modelWithDictionary:data[i]];
                                               [weakSelf.datas addObject:model];
                                               [weakSelf.tableView reloadData];
                                           }
                                           
                                           [weakSelf.tableView.header endRefreshing];
//                                           if (self.page != 0) {
                                               [weakSelf checkFooterCanRefresh];
//                                           }

                                           
                                       }else{
                                           
                                       }
                                       
                                   }
                                    failed:^(NSError *error) {
                                        NSLog(@"%@",error);
                                    }];
}

//自动登录，获取profile（根据keychian里面的userid）
- (void)autoLogin
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
    NSString *userId = [keychain objectForKey:(id)kSecValueData];
    //保存到单例类
    UserInfo *user = [UserInfo sharedUserInfo];
    user.userId = userId;
 
//    根据userid获取profile
    [RequestApi getUserInfoWithUserId:userId success:^(NSDictionary *successData) {
        NSLog(@"getProfile--->>>>%@",successData);
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *data = [successData valueNotNullForKey:kRequestReturnData];
            
            [user setupDataWithDic:data];

         }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}


- (void)loadNew
{
    self.page = 0;
    [self getRecentInfo];
}

- (void)loadMore
{
    self.page++;
    [self getRecentInfo];
}

- (void)checkFooterCanRefresh
{
    _tableView.footer.hidden = (self.datas.count == 0);
    if (self.datas.count == self.lastCount) {
        [self.tableView.footer noticeNoMoreData];
    }else{
        [self.tableView.footer endRefreshing];
        self.lastCount = self.datas.count;
    }
}



#pragma mark - 门禁配置
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
    
    //with default keep lock open time
    [SVProgressHUD showWithStatus:@"正在开门, 请稍后..."];
    if ([self.peripheralArray count] > 0) {
        [[OneKeyApi shareInstance] oneKeyOpenDevice:self.peripheralArray[0] andDevicePassword:@"12345678"];
    }
}

//扫描设备超时回调
- (void)scanDeviceEndCallBack
{
    [SVProgressHUD showErrorWithStatus:@"没有发现门禁设备, 请靠近门禁设备"];
}

/**
 *  断开连接回调
 */
- (void)disconnectDeviceCallBack
{
    
}

/**
 *  蓝牙状态回调
 *
 *  @param state 状态值
 */
- (void)updateBluetoothStateCallBack:(CBCentralManagerState)state
{
    switch (state) {
        case CBCentralManagerStatePoweredOff:
        {
            NSString *str = @"连接失败了,请您再检查一下您的手机蓝牙是否开启,然后再试一次吧";
            [SVProgressHUD showSuccessWithStatus:str];
        }
            break;
        case CBCentralManagerStateResetting:
        {
            [SVProgressHUD showSuccessWithStatus:@"请重试"];
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSString *str = @"检测到您的手机不支持蓝牙4.0,所以建立不了连接.建议更换您,的手机再试试。";
            [SVProgressHUD showSuccessWithStatus:str];
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSString *str = @"连接失败了,请您再检查一下您的手机蓝牙是否开启,然后再试一次吧";
            [SVProgressHUD showSuccessWithStatus:str];
        }
            break;
        case CBCentralManagerStateUnknown:
            [SVProgressHUD showSuccessWithStatus:@"请重试"];
            break;
        default:
            break;
    }
}


/**
 *  开门回调
 *
 *  @param battery
 *  @param result   执行结果返回状态
 */
- (void)openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString*) devId
{
//    DHBLE_RESULT_SERVICE_NOT_FOUND = -1,
//    METHOD_ERR_DEVICE_NOT_CONN = -2,
//    METHOD_ERR_FROM_DEV = -3,
//    METHOD_NOT_SUPPORT_BLE = -4,
//    METHOD_BLE_NOT_ENABLED = -5,
//    METHOD_OPERATE_TIMEOUT = -6,
//    METHOD_PARAM_ERR = -8,
//    METHOD_NOT_SCAN_DEV = -9,
//    METHOD_SERVICE_NOT_FOUND = -10,
//    DHBLE_RESULT_OK = 0,
//    DHBLE_RESULT_NG,
//    DHBLE_RESULT_SYSTEM_ERROR, /* 系统密码错误 */
//    DHBLE_RESULT_LOCK_ID_ERROR, /* 锁ID不一致 */
//    DHBLE_RESULT_PASSWORD_ERROR, /* 用户密码错误 */
//    DHBLE_RESULT_TIMEOUT, /* 超时 */
//    DHBLE_RESULT_NO_LOGIN, /* 没有登录 */
//    DHBLE_RESULT_KEY_EXIST, /* 钥匙己经存在 */
//    DHBLE_RESULT_KEY_FULL, /* 钥匙己满 */
//    DHBLE_RESULT_KEY_EMPTY, /* 钥匙为空 */
    if (result < 0) {
        [SVProgressHUD showWithStatus:@"状态未知,请重试"];
    }else if (result == 0){
         [SVProgressHUD showWithStatus:@"门已经打开"];
    }else if (result == 1){
        [SVProgressHUD showWithStatus:@"状态未知"];
    }else if (result == 2){
        [SVProgressHUD showWithStatus:@"系统密码错误"];
    }else if (result == 3){
        [SVProgressHUD showWithStatus:@"锁ID不一致"];
    }else if (result == 4){
        [SVProgressHUD showWithStatus:@"用户密码错误"];
    }else if (result == 5){
        [SVProgressHUD showWithStatus:@"超时"];
    }else if (result == 6){
        [SVProgressHUD showWithStatus:@"没有登录"];
    }else if (result == 7){
        [SVProgressHUD showWithStatus:@"钥匙己经存在"];
    }else if (result == 8){
        [SVProgressHUD showWithStatus:@"钥匙己满"];
    }else if (result == 9){
        [SVProgressHUD showWithStatus:@"钥匙为空"];
    }
}

//- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery
//{
//    
//}
@end
