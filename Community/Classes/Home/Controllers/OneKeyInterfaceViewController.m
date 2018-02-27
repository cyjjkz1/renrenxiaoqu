//
//  OneKeyInterfaceViewController.m
//  BLKApp
//
//  Created by roryyang on 16/8/13.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import "OneKeyInterfaceViewController.h"
#import "DHTextFile.h"
#import "BatchAddKeyController.h"
//#import "AutoViewController.h"

@interface OneKeyInterfaceViewController ()

@property (nonatomic,retain) DHTextFile* recMsgEditTxt, *deviceIdEditText, *devicePswEditText,
*deviceNewPswEditText, *userIdEditText, *keyPswEditText,
*devNameEditText, *openRssiEditText, *disConnectTimeEditText,
*txPowerEditText, *activeTimeEditText, *visiTimeEditText,
*visiCodeEditText,*ip1EditText, *ip2EditText, *ip3EditText,
*ip4EditText,*portEditText, *domainEditText;


@property (nonatomic,retain) UILabel* devIdLabel,*devPswLable,*devNewPswLabel,*userIdLabel,
*keyPswLabel,*devNameLabel,*notOneKeyLabel;
@property (nonatomic,retain)UIButton *selectAccessBtn, *oneKeyOpenDeviceBtn, *oneKeyOpenDeviceWidthUserIdBtn,*oneKeyCloseDeviceBtn,
*oneKeyOpenDevKeepTimeBtn, *oneKeyDisconnDeviceBtn,
*oneKeyAddPaswdAndCardKeyBtn, *oneKeyDeletePaswdAndCardKeyBtn,
*oneKeyReadPaswdAndCardKeyBtn, *oneKeyFlashAddKeyBtn,
*oneKeyFlashDeleteKeyBtn, *oneKeyReadClockBtn, *oneKeySetClockBtn,
*oneKeyServiceConfigDeviceBtn,*oneKeyConfigIpBtn, *oneKeyChangeDevPswBtn,
*oneKeyChangeDevNameBtn, *oneKeyReadVerInfoBtn,
*oneKeyConfigDeviceBtn, *oneKeyReadDeviceConfigBtn, *oneKeyAddPswBtn,
*oneKeyDeletePswBtn, *connDevBtn, *openDevBtn, *visitCodeBtn,*batchAddKeyBtn;


@property (nonatomic, assign) UInt32 currentItemIndex;
@property (nonatomic, assign) UInt32 itemCount;
@property (nonatomic, assign) UInt32 itenNumPerTime;
@property (nonatomic, assign) UInt32 frameWidth;
@property (nonatomic, assign) UInt32 frameHeight;
@property (nonatomic, assign) UInt32 padding;
@property (nonatomic, assign) UInt32 margining;
@property (nonatomic, assign) UInt32 viewHeight;
@property (nonatomic, assign) UInt32 viewWidth;


@property (nonatomic, strong) NSString* devPswStr,*devNewPswStr,*userIdStr,*keyPswStr,*devNameStr,
                            *openRssiStr,*disConnStr,*txPowerStr,*activeTimeStr,*visitTimeStr;

@end

@implementation OneKeyInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    [self initStyle];
    [self initTarget];
    [self addGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    _sensor = [DHBle shareInstance];
    _sensor.delegate = self;
    _peripheral = _sensor.activePeripheral;
    [_sensor enableNSLog:YES];
}


-(void)addGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}

-(void)initView{
    _myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    _myscrollview.directionalLockEnabled = YES; //只能一个方向滑动
    _myscrollview.pagingEnabled = NO; //是否翻页
    _myscrollview.backgroundColor= [UIColor whiteColor];
    _myscrollview.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _myscrollview.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动指示的风格
    _myscrollview.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _myscrollview.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 53*33);
    [_myscrollview setContentSize:newSize];
    
    //Id layout
    UIView *idView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _frameWidth, _viewHeight)];
    _devIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _deviceIdEditText = [[DHTextFile alloc]initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    
    _devIdLabel.text = @"设备ID";
    [idView addSubview:_devIdLabel];
    [idView addSubview:_deviceIdEditText];
    _deviceIdEditText.text = [_sensor getDeviceIdForStringValue:_peripheral];
    [_myscrollview addSubview:idView];
    
    int yPos = _viewHeight + _margining;
    int index = 2;
    
    //psw view
    UIView *pswView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _devPswLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _devicePswEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    _devPswLable.text = @"设备密码";
    _devicePswEditText.text = @"12345678";
    //_devicePswEditText.text = @"68549632";
    [pswView addSubview:_devPswLable];
    [pswView addSubview:_devicePswEditText];
    [_myscrollview addSubview:pswView];
    
    yPos = (_viewHeight + _margining)*index++;
    //new psw and userid.
    UIView *newPswView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _devNewPswLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _deviceNewPswEditText = [[DHTextFile alloc]initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    _devNewPswLabel.text = @"设备新密码";
    _deviceNewPswEditText.text = @"12345678";
    [newPswView addSubview:_devNewPswLabel];
    [newPswView addSubview:_deviceNewPswEditText];
    [_myscrollview addSubview:newPswView];
    
    yPos = (_viewHeight + _margining)*index++;
    UIView *userLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _userIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _userIdEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    _userIdLabel.text=@"用户ID";
    _userIdEditText.text = @"88768327";
    [userLabelView addSubview:_userIdLabel];
    [userLabelView addSubview:_userIdEditText];
    [_myscrollview addSubview:userLabelView];

    yPos = (_viewHeight + _margining)*index++;
    UIView *keyPswView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _keyPswLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _keyPswEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    _keyPswLabel.text=@"设备密码";
    _keyPswEditText.text = @"12345678";
    [keyPswView addSubview:_keyPswLabel];
    [keyPswView addSubview:_keyPswEditText];
    [_myscrollview addSubview:keyPswView];
    
    
    yPos = (_viewHeight + _margining)*index++;
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _devNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _devNameEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    _devNameLabel.text=@"设备名称";
    _devNameEditText.text = [_sensor getDeviceName:_peripheral];
    [nameView addSubview:_devNameLabel];
    [nameView addSubview:_devNameEditText];
    [_myscrollview addSubview:nameView];
    
    
    yPos = (_viewHeight + _margining)*index++;
    
    UIView *configView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _openRssiEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(0, 0, _viewWidth/2-5, _viewHeight)];
    _disConnectTimeEditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth/2+2, 0, _viewWidth/2-5, _viewHeight)];
    _txPowerEditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth/2-5, _viewHeight)];
   _activeTimeEditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_viewWidth/2, 0, _viewWidth/2-5, _viewHeight)];
    _openRssiEditText.placeholder = @"openRSSI";
    _disConnectTimeEditText.placeholder = @"disConnect";
    _txPowerEditText.placeholder = @"txPower";
    _activeTimeEditText.placeholder = @"activeTime";
    [configView addSubview:_openRssiEditText];
    [configView addSubview:_disConnectTimeEditText];
    [configView addSubview:_txPowerEditText];
    [configView addSubview:_activeTimeEditText];
    [_myscrollview addSubview:configView];
    
    
    //Receive message.
    yPos = (_viewHeight + _margining)*index++;
    UIView *recMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight*2)];
    _recMsgEditTxt = [[DHTextFile alloc] initWithFrame:CGRectMake(0, 0, _frameWidth, _viewHeight*2)];
    UIFont* cellFont = [UIFont fontWithName:@"Helvetica" size:12];
    [_recMsgEditTxt setFont:cellFont];
    [recMsgView addSubview:_recMsgEditTxt];
    [_myscrollview addSubview:recMsgView];
    
    
    /** init buttons **/
    index++;
    yPos = (_viewHeight + _margining)*index++;
    _selectAccessBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_selectAccessBtn setTitle:@"选择蓝牙" forState:UIControlStateNormal];
    _selectAccessBtn.backgroundColor = [UIColor grayColor];
    [_selectAccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_selectAccessBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyOpenDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyOpenDeviceBtn setTitle:@"一键开门" forState:UIControlStateNormal];
    _oneKeyOpenDeviceBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyOpenDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyOpenDeviceBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyOpenDevKeepTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyOpenDevKeepTimeBtn setTitle:@"一键开门（带关闭时间）" forState:UIControlStateNormal];
    _oneKeyOpenDevKeepTimeBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyOpenDevKeepTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyOpenDevKeepTimeBtn];
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyCloseDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyCloseDeviceBtn setTitle:@"一键关门（车位锁)" forState:UIControlStateNormal];
    _oneKeyCloseDeviceBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyCloseDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyCloseDeviceBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyOpenDeviceWidthUserIdBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyOpenDeviceWidthUserIdBtn setTitle:@"一键开门(带韦根)" forState:UIControlStateNormal];
    _oneKeyOpenDeviceWidthUserIdBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyOpenDeviceWidthUserIdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyOpenDeviceWidthUserIdBtn];
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyDisconnDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyDisconnDeviceBtn setTitle:@"一键断开连接" forState:UIControlStateNormal];
    _oneKeyDisconnDeviceBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyDisconnDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyDisconnDeviceBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyAddPaswdAndCardKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyAddPaswdAndCardKeyBtn setTitle:@"学习卡片" forState:UIControlStateNormal];
    _oneKeyAddPaswdAndCardKeyBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyAddPaswdAndCardKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyAddPaswdAndCardKeyBtn];
    
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyDeletePaswdAndCardKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyDeletePaswdAndCardKeyBtn setTitle:@"删除学习卡片" forState:UIControlStateNormal];
    _oneKeyDeletePaswdAndCardKeyBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyDeletePaswdAndCardKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyDeletePaswdAndCardKeyBtn];
    
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyReadPaswdAndCardKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyReadPaswdAndCardKeyBtn setTitle:@"读取卡片" forState:UIControlStateNormal];
    _oneKeyReadPaswdAndCardKeyBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyReadPaswdAndCardKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyReadPaswdAndCardKeyBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyAddPswBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyAddPswBtn setTitle:@"添加密码" forState:UIControlStateNormal];
    _oneKeyAddPswBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyAddPswBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyAddPswBtn];
    
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyDeletePswBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyDeletePswBtn setTitle:@"删除密码" forState:UIControlStateNormal];
    _oneKeyDeletePswBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyDeletePswBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyDeletePswBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyFlashAddKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyFlashAddKeyBtn setTitle:@"发卡片" forState:UIControlStateNormal];
    _oneKeyFlashAddKeyBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyFlashAddKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyFlashAddKeyBtn];
    
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyFlashDeleteKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyFlashDeleteKeyBtn setTitle:@"删除下发的卡片" forState:UIControlStateNormal];
    _oneKeyFlashDeleteKeyBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyFlashDeleteKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyFlashDeleteKeyBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyReadClockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyReadClockBtn setTitle:@"读取时钟" forState:UIControlStateNormal];
    _oneKeyReadClockBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyReadClockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyReadClockBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeySetClockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeySetClockBtn setTitle:@"设置时钟" forState:UIControlStateNormal];
    _oneKeySetClockBtn.backgroundColor = [UIColor grayColor];
    [_oneKeySetClockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeySetClockBtn];
    
    //IP
    yPos = (_viewHeight + _margining)*index++;
    UIView *configIPView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _ip1EditText = [[DHTextFile alloc] initWithFrame:CGRectMake(0, 0, _viewWidth/2-5, _viewHeight)];
    _ip2EditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth/2+2, 0, _viewWidth/2-5, _viewHeight)];
    _ip3EditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth/2-5, _viewHeight)];
    _ip4EditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_viewWidth/2, 0, _viewWidth/2-5, _viewHeight)];
    _ip1EditText.text = @"192";
    _ip2EditText.text = @"168";
    _ip3EditText.text = @"1";
    _ip4EditText.text = @"100";
    
    [configIPView addSubview:_ip1EditText];
    [configIPView addSubview:_ip2EditText];
    [configIPView addSubview:_ip3EditText];
    [configIPView addSubview:_ip4EditText];
    [_myscrollview addSubview:configIPView];
    
    //Port and domain
    yPos = (_viewHeight + _margining)*index++;
    UIView *configPortDomainView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    UITextView* portTxtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth/2-5, _viewHeight)];
    _portEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth/2+2, 0, _viewWidth/2-5, _viewHeight)];
    _domainEditText= [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth/2-5, _viewHeight)];
    portTxtView.text = @"端口:";
    _portEditText.text = @"60000";
    _domainEditText.placeholder = @"域名:";
    
    [configPortDomainView addSubview:portTxtView];
    [configPortDomainView addSubview:_portEditText];
    [configPortDomainView addSubview:_domainEditText];
    [_myscrollview addSubview:configPortDomainView];
    
    //Config IP Button
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyConfigIpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyConfigIpBtn setTitle:@"配置服务器ip和端口" forState:UIControlStateNormal];
    _oneKeyConfigIpBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyConfigIpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyConfigIpBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyServiceConfigDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyServiceConfigDeviceBtn setTitle:@"配置心跳" forState:UIControlStateNormal];
    _oneKeyServiceConfigDeviceBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyServiceConfigDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyServiceConfigDeviceBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyChangeDevPswBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyChangeDevPswBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    _oneKeyChangeDevPswBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyChangeDevPswBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyChangeDevPswBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyChangeDevNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyChangeDevNameBtn setTitle:@"修改名称" forState:UIControlStateNormal];
    _oneKeyChangeDevNameBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyChangeDevNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyChangeDevNameBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyReadVerInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyReadVerInfoBtn setTitle:@"读取版本" forState:UIControlStateNormal];
    _oneKeyReadVerInfoBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyReadVerInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyReadVerInfoBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyReadDeviceConfigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyReadDeviceConfigBtn setTitle:@"读取配置" forState:UIControlStateNormal];
    _oneKeyReadDeviceConfigBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyReadDeviceConfigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyReadDeviceConfigBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _oneKeyConfigDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_oneKeyConfigDeviceBtn setTitle:@"配置门禁" forState:UIControlStateNormal];
    _oneKeyConfigDeviceBtn.backgroundColor = [UIColor grayColor];
    [_oneKeyConfigDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_oneKeyConfigDeviceBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _notOneKeyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _notOneKeyLabel.text =@"非一键接口";
    [_myscrollview addSubview:_notOneKeyLabel];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _connDevBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_connDevBtn setTitle:@"单独连接" forState:UIControlStateNormal];
    _connDevBtn.backgroundColor = [UIColor grayColor];
    [_connDevBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_connDevBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _openDevBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_openDevBtn setTitle:@"快速开锁" forState:UIControlStateNormal];
    _openDevBtn.backgroundColor = [UIColor grayColor];
    [_openDevBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_openDevBtn];
    
    
    yPos = (_viewHeight + _margining)*index++;
    UIView *visitView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    _visitCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _visiCodeEditText = [[DHTextFile alloc] initWithFrame:CGRectMake(_viewWidth+_margining, 0, _viewWidth, _viewHeight)];
    [_visitCodeBtn setTitle: @"生成访客码" forState:UIControlStateNormal ];
    _visitCodeBtn.backgroundColor = [UIColor grayColor];
    [_visitCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [visitView addSubview:_visitCodeBtn];
    [visitView addSubview:_visiCodeEditText];
    [_myscrollview addSubview:visitView];
    
    
    yPos = (_viewHeight + _margining)*index++;
    _batchAddKeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _frameWidth, _viewHeight)];
    [_batchAddKeyBtn setTitle:@"批量发卡" forState:UIControlStateNormal];
    _batchAddKeyBtn.backgroundColor = [UIColor grayColor];
    [_batchAddKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_batchAddKeyBtn];
    
    
    //add scrollview.
    [self.view addSubview:_myscrollview];
}


-(void) initData{
    _currentItemIndex = 0;
    _itemCount = 0;
    _itenNumPerTime = 2;
    _frameWidth = self.view.frame.size.width;
    _frameHeight = self.view.frame.size.height;
    _padding = 3;
    _margining = 3;
    _viewHeight = 35;
    _viewWidth = (_frameWidth-_margining*2) /2;
    
    _sensor = [DHBle shareInstance];
    _sensor.delegate = self;
    _peripheral = _sensor.activePeripheral;
}

-(void) initStyle{
    [_recMsgEditTxt initView];
    [_deviceIdEditText initView];
    [_devicePswEditText initView];
    [_deviceNewPswEditText initView];
    [_userIdEditText initView];
    [_keyPswEditText initView];
    [_devNameEditText initView];
    [_openRssiEditText initView];
    [_disConnectTimeEditText initView];
    [_txPowerEditText initView];
    [_activeTimeEditText initView];
    [_visiTimeEditText initView];
    [_visiCodeEditText initView];
    [_ip1EditText initView];
    [_ip2EditText initView];
    [_ip3EditText initView];
    [_ip4EditText initView];
    [_portEditText initView];
    [_domainEditText initView];
}

-(void) initTarget{
    [ _selectAccessBtn addTarget:self action:@selector(backToScanSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyOpenDeviceBtn addTarget:self action:@selector(onekeyOpenDevSensorSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyOpenDeviceWidthUserIdBtn addTarget:self action:@selector(onekeyOpenDevWithUserIdSensorSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyCloseDeviceBtn addTarget:self action:@selector(onekeyCloseDevSensorSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyOpenDevKeepTimeBtn addTarget:self action:@selector(onekeyOpenDevKeepTimeSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyDisconnDeviceBtn addTarget:self action:@selector(onekeyDisConnSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyAddPaswdAndCardKeyBtn addTarget:self action:@selector(onekeyAddPswAndCardSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyDeletePaswdAndCardKeyBtn addTarget:self action:@selector(onekeyDeletePswAndCardSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyReadPaswdAndCardKeyBtn addTarget:self action:@selector(onekeyReadPswAndCardSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyFlashAddKeyBtn addTarget:self action:@selector(onekeyFlashAddKeySensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyFlashDeleteKeyBtn addTarget:self action:@selector(onekeyFlashDelKeySensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyReadClockBtn addTarget:self action:@selector(onekeyReadClockSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeySetClockBtn addTarget:self action:@selector(onekeySetClockSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyServiceConfigDeviceBtn addTarget:self action:@selector(onekeyServiceConfigSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyConfigIpBtn addTarget:self action:@selector(onekeyConfigServerIpSensor) forControlEvents:UIControlEventTouchUpInside];
    ;
    [_oneKeyChangeDevPswBtn addTarget:self action:@selector(onekeyChangeDevPswSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyChangeDevNameBtn addTarget:self action:@selector(onekeyChngeDevNameSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyReadVerInfoBtn addTarget:self action:@selector(onekeyReadVerSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyConfigDeviceBtn addTarget:self action:@selector(onekeyConfigDevSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyReadDeviceConfigBtn addTarget:self action:@selector(onekeyReadDevConfgSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyAddPswBtn addTarget:self action:@selector(onekeyAddPswSensor) forControlEvents:UIControlEventTouchUpInside];
    [_oneKeyDeletePswBtn addTarget:self action:@selector(onekeyDelPswSensor) forControlEvents:UIControlEventTouchUpInside];
    [_connDevBtn addTarget:self action:@selector(connLockSensor) forControlEvents:UIControlEventTouchUpInside];
    [_openDevBtn addTarget:self action:@selector(openLockSensor) forControlEvents:UIControlEventTouchUpInside];
    [_visitCodeBtn addTarget:self action:@selector(visitCodeSensor) forControlEvents:UIControlEventTouchUpInside];
    [_batchAddKeyBtn addTarget:self action:@selector(batchAddSensor) forControlEvents:UIControlEventTouchUpInside];
}
-(void)parseFiledData{
    _devPswStr = _devicePswEditText.text;
    _devNewPswStr = _deviceNewPswEditText.text;
    _userIdStr = _userIdEditText.text;
    _keyPswStr = _keyPswEditText.text;
    _devNameStr = _devNameEditText.text;
    _openRssiStr = _openRssiEditText.text;
    _disConnStr = _disConnectTimeEditText.text;
    _txPowerStr = _txPowerEditText.text;
    _activeTimeStr = _activeTimeEditText.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backToScanSensor{
    if(_sensor.activePeripheral && _sensor.activePeripheral.state == CBPeripheralStateConnected){
        [_sensor disconnectDevice:_sensor.activePeripheral];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onekeyOpenDevSensorSensor{
    [self parseFiledData];
    [_sensor oneKeyOpenDevice:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr openType:TYPE_OPEN_LOCK];
}

-(void)onekeyOpenDevWithUserIdSensorSensor{
    [self parseFiledData];
    [_sensor oneKeyOpenDeviceUserId:_peripheral deviceNum:[_sensor getDeviceId:_peripheral] devicePassword:[_sensor stringToUInt32:_devPswStr] userId:[_sensor stringToUInt32:_userIdStr]];
}

-(void)onekeyCloseDevSensorSensor{
    [self parseFiledData];
    [_sensor oneKeyOpenDevice:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr openType:TYPE_CLOSE_LOCK];
}
-(void)onekeyOpenDevKeepTimeSensor{
    [self parseFiledData];
    [_sensor openDevice:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr keepOpenTime:10];
}
-(void)onekeyDisConnSensor{
    [self parseFiledData];
    [_sensor disconnectDevice:_peripheral];
}
-(void)onekeyAddPswAndCardSensor{
    [self parseFiledData];
    UInt32 pswCardType = 3;
    NSString* userIdStr = _userIdStr;
    NSString* keyInfoStr =@"00000000";// when pswCardType == 3, then keyInfoStr = "00000000";
    //valid time
    int year = 2018;
    int month = 10;
    int day = 11;
    [_sensor oneKeyAddPaswdAndCardKey:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr type:pswCardType userId:userIdStr KeyInfo:keyInfoStr activeYear:year activeMonth:month activeDay:day];
}
-(void)onekeyDeletePswAndCardSensor{
    [self parseFiledData];
    UInt32 pswCardType = 3;
    NSString* userIdStr = @"88768327";
    [_sensor oneKeyDeletePaswdAndCardKey:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr type:pswCardType userId:userIdStr];
    
}
-(void)onekeyReadPswAndCardSensor{
    [self parseFiledData];
    int keyIndex = 0;
    [_sensor oneKeyReadPaswdAndCardKey:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr keyIndex:keyIndex];
}
-(void)onekeyFlashAddKeySensor{
    [self parseFiledData];
    UInt32 pswCardType = 3;
    NSArray* keyList = nil;
    NSArray* dateList = nil;
    keyList = [NSArray arrayWithObjects:@"458D51F9",nil];
    dateList = [NSArray arrayWithObjects:[NSDate date] ,nil];
    
    [_sensor oneKeyFlashAddKey:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr type:pswCardType addKeyIdList:keyList addActiveDateList:dateList];
    
}
-(void)onekeyFlashDelKeySensor{
    [self parseFiledData];
    
    UInt32 pswCardType = 3;
    NSString* delKeyId = @"458D51F9";
    [_sensor oneKeyFlashDeleteKey:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr type:pswCardType delKeyId:delKeyId];
    
}
-(void)onekeyReadClockSensor{
    [self parseFiledData];
    [_sensor oneKeyReadClock:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr];
    
}
-(void)onekeySetClockSensor{
    [self parseFiledData];
    [_sensor oneKeyReadClock:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr];
    
}
-(void)onekeyServiceConfigSensor{
    [self parseFiledData];
    UInt32 uploadRecord = 1; //1: auto upload; 0: do not upload.
    UInt32 heartBeat = 10;  // 10 seconds
    [_sensor oneKeyServiceConfigDevice:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr uploadRecordMask:uploadRecord heartBeatT:heartBeat];
}

-(void)onekeyConfigServerIpSensor{
    [self parseFiledData];
    UInt16 port = [_portEditText.text  intValue];
    UInt8 ip1 = [_ip1EditText.text intValue];
    UInt8 ip2 = [_ip2EditText.text intValue];
    UInt8 ip3 = [_ip3EditText.text intValue];
    UInt8 ip4 = [_ip4EditText.text intValue];
    NSString* domain = _domainEditText.text;
    
    [_sensor oneKeyConfigServer:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr port:port ip1:ip1 ip2:ip2 ip3:ip3 ip4:ip4 domain:domain];
}

-(void)onekeyChangeDevPswSensor{
    [self parseFiledData];
    [_sensor oneKeyChangeDevPsw:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] oldPassword:_devPswStr newPassword:_devNewPswStr];
}
-(void)onekeyChngeDevNameSensor{
    [self parseFiledData];
    long nameLength = _devNameStr.length;
    char* name = [_devNameStr UTF8String];
    [_sensor oneKeyChangeDevName:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr deviceName:name nameLength:nameLength];
}
-(void)onekeyReadVerSensor{
    [self parseFiledData];
    [_sensor oneKeyReadVerInfo:_peripheral];
}
-(void)onekeyConfigDevSensor{
    [self parseFiledData];
    //hhhh
    //[_sensor oneKeySetIbeaconConfig:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr advTime:[_openRssiStr intValue] txPower:[_disConnStr intValue] main:[_txPowerStr intValue] sub:[_activeTimeStr intValue]];
    
    //NSLog(@"%d,%d,%d,%d",[_openRssiStr intValue],[_disConnStr intValue],[_txPowerStr intValue],[_activeTimeStr intValue]);
    [_sensor oneKeyConfigDevice:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr activeRSSI:[_openRssiStr intValue] disConnectTime:[_disConnStr intValue] txPower:[_txPowerStr intValue] activeTime:[_activeTimeStr intValue]];
    
}

-(void)onekeyReadDevConfgSensor{
    [self parseFiledData];
    [_sensor oneKeyReadDeviceConfig:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr];
    //[_sensor oneKeyReadIbeaconConfig:_peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:_devPswStr];
}

-(void)onekeyAddPswSensor{
    [self parseFiledData];
    int pswCardType = 2;
    NSString* userId = @"88768327";
    NSString* keyInfo=@"12345600";
    int year = 2018;
    int month = 10;
    int day = 11;
    [_sensor oneKeyAddPaswdAndCardKey:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr type:pswCardType userId:userId KeyInfo:keyInfo activeYear:year activeMonth:month activeDay:day];
}

-(void)onekeyDelPswSensor{
    [self parseFiledData];
    int pswCardType = 2;
    NSString* userId = @"88768327";
    [_sensor oneKeyDeletePaswdAndCardKey:_peripheral deviceNumStr:[_sensor getDeviceIdForStringValue:_peripheral] devicePasswordStr:_devPswStr type:pswCardType userId:userId];
}

-(void)connLockSensor{
    [self parseFiledData];
    [_sensor connectDevice:_peripheral];
}

-(void)openLockSensor{
    [self parseFiledData];
    [_sensor readVerInfo:_peripheral];
    //[_sensor openDevice:_peripheral deviceNum:[_sensor getDeviceId:_peripheral] devicePassword:[_sensor stringToUInt32:_devPswStr]];
}

-(void)visitCodeSensor{
    [self parseFiledData];
    int lockActiveTime = 15;
    NSString* code = [_sensor generateVisitePassword:[_sensor getDeviceId:_peripheral] devicePassword:[_sensor stringToUInt32:_devPswStr] activeTime:lockActiveTime];
    [_visiCodeEditText setText:code];
}

-(void)batchAddSensor{
    //[self parseFiledData];
//    BatchAddKeyController* bachAddController = [[BatchAddKeyController alloc]init];
//    [self.navigationController pushViewController:bachAddController animated:YES];
    
   //  AutoViewController *bachAddController  = [[AutoViewController alloc]init];
   // [self.navigationController pushViewController:bachAddController animated:YES];
}

#pragma mark - Navigation
/**
 *  断开设备回调
 */
- (void)disconnectDeviceCallBack{
    //[_recMsgEditTxt setText:@"disconnectDeviceCallBack"];
}

-(void)connectDeviceCallBack:(DHBleResultType)result{
    [_recMsgEditTxt setText:@"connectDeviceCallBack"];
}


/**
 *  扫描设备设备回调
 *
 *  @param peripheral 设备对象
 *  @param level 信号强度
 */
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    
}


/**
 *  扫描设备设备超时回调
 *
 */
- (void)scanDeviceEndCallBack{
    
}


/**
 *  读取版本信息回调
 *
 *  @param pSw
 *  @param code
 *  @param flag
 *  @param pHw
 *  @param result   执行结果返回状态
 */
- (void)readVerInfoCallBack:(DHBleResultType)result hwInfo:(NSString*)pHw swInfo:(NSString*)pSw code:(UInt8)code configFlag:(UInt8)flag{
    NSString* txt = nil;
    if(result == DHBLE_RESULT_OK){
        txt = [NSString stringWithFormat:@"readVerInfoCallBack result: %ld hw:%@  sw:%@ code:%d configFlag:%d",result,pHw,pSw,code,flag];
    }else{
        txt = [NSString stringWithFormat:@"readVerInfoCallBack result: %ld ",result];
    }
   
    [_recMsgEditTxt setText:txt];
    
}


/**
 *  读取设备信息回调
 *
 *  @param deviceId 设备id
 *  @param status   配置状态
 *  @param result   执行结果返回状态
 */
- (void)readDeviceInfoCallBack:(DHBleResultType)result device:(UInt32)deviceId configStatus:(Byte)status{
    NSString* txt = [NSString stringWithFormat:@"readDeviceInfoCallBack deviceId: %@ status:%d",[_sensor uInt32ToString:deviceId],status];
    [_recMsgEditTxt setText:txt];
}


/**
 *  配置设备信息回调
 *
 *  @param result   执行结果返回状态
 */
- (void)configDeviceCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"configDeviceCallBack result: %ld",(long)result];
    [_recMsgEditTxt setText:txt];
    
}


/**
 *  读取配置信息回调
 *
 *  @param advTime
 *  @param connectTime
 *  @param power
 *  @param actTime
 *  @param result   执行结果返回状态
 */
- (void)readConfigCallBack:(DHBleResultType)result activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime{
    NSString* txt = [NSString stringWithFormat:@"readConfigCallBack result: %ld activeRSSI:%u  disConnectTime:%u txPower:%u  activeTime:%u",(long)result,level,disConnectTime,power,actTime];
    [_recMsgEditTxt setText:txt];
    _openRssiEditText.text = [NSString stringWithFormat:@"%d",level];
    _disConnectTimeEditText.text =[NSString stringWithFormat:@"%d",disConnectTime];
    _txPowerEditText.text = [NSString stringWithFormat:@"%d",power];
    _activeTimeEditText.text = [NSString stringWithFormat:@"%d",actTime];
}

/**
 *  修改设备密码回调
 *
 *  @param result   执行结果返回状态
 */
- (void)modifyPasswordCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"modifyPasswordCallBack result: %ld",(long)result];
    [_recMsgEditTxt setText:txt];
    
}


/**
 *  修改设备名称回调
 *
 *  @param result   执行结果返回状态
 */
- (void)modifyNameCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"modifyNameCallBack result: %ld",(long)result];
    [_recMsgEditTxt setText:txt];
}

/**
 *  读取输入信息回调
 *
 *  @param status
 *  @param result   执行结果返回状态
 */
- (void)readInputCallBack:(DHBleResultType)result inputStatus:(Byte)status{
    
    NSString* txt = [NSString stringWithFormat:@"readInputCallBack result: %ld status:%u",(long)result,status];
    [_recMsgEditTxt setText:txt];
}


/**
 *  打开或者关闭设备回调
 *
 *  @param battery
 *  @param result   执行结果返回状态
 */
- (void)openCloseDeviceIICallBack:(DHBleResultType)result deviceBattery:(Byte)battery deviceId:(NSString*) devId{
    NSString* txt = [NSString stringWithFormat:@"openCloseDeviceIICallBack result: %ld battery:%u devId:%@",(long)result,battery,devId];
    [_recMsgEditTxt setText:txt];
    
}

- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery{
    NSString* txt = [NSString stringWithFormat:@"openCloseDeviceCallBack result: %ld battery:%u",(long)result,battery];
    //[_recMsgEditTxt setText:txt];
}

/**
 *  重置设备回调
 *
 *  @param result   执行结果返回状态
 */
- (void)resetDevcieCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"resetDevcieCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}


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
- (void)readClockCallBack:(DHBleResultType)result year:(UInt16)year month:(Byte)month day:(Byte)day hour:(Byte)hour minute:(Byte)minute second:(Byte)second{
    
    NSString* txt = [NSString stringWithFormat:@"readClockCallBack result: %ld year:%u month:%u day:%u hour:%u minute:%u second:%u",(long)result,year,month,day,hour,minute,second];
    [_recMsgEditTxt setText:txt];
}


/**
 *  设置时间
 *
 *  @param result   执行结果返回状态
 */
- (void)setClockCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"setClockCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}





// for ibeacon start
//- (void)readIbeaconConfigCallBack:(DHBleResultType)result advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor;
//- (void)setIbeaconConfigCallBack:(DHBleResultType)result;
- (void)setIbeaconUUIDCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"setIbeaconUUIDCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}
-(void) readIbeaconConfigCallBack:(DHBleResultType)result advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor{
    NSString* txt = [NSString stringWithFormat:@"readIbeaconConfigCallBack result:%ld advTime:%ld txPower:%ld major:%ld minor:%ld",(long)result,(long)advInt,(long)power,(long)(long)major,(long)minor];
    [_recMsgEditTxt setText:txt];
    
    _openRssiEditText.text = [NSString stringWithFormat:@"%d",advInt];
    _disConnectTimeEditText.text =[NSString stringWithFormat:@"%d",power];
    _txPowerEditText.text = [NSString stringWithFormat:@"%d",major];
    _activeTimeEditText.text = [NSString stringWithFormat:@"%d",minor];
}
- (void)setIbeaconConfigCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"setIbeaconConfigCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}
// for ibeacon end

// for config Wifi start
- (void)configWifiCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"configWifiCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
    
}
- (void)configServerCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"configServerCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
    
}
- (void)configWifiHeartBeatCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"configWifiHeartBeatCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
    
}
// for config Wifi end

// for home lock start
- (void)addPaswdAndCardKeyCallBack:(DHBleResultType)result{
    
    NSString* txt = [NSString stringWithFormat:@"addPaswdAndCardKeyCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}
- (void)flashAddKeyCallBack:(DHBleResultType) result{
    
    NSString* txt = [NSString stringWithFormat:@"flashAddKeyCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}
- (void)deletePaswdAndCardKeyCallBack:(DHBleResultType)result{
    NSString* txt = [NSString stringWithFormat:@"deletePaswdAndCardKeyCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
    
}
- (void)flashDeleteKeyCallBack:(DHBleResultType) result{
    
    NSString* txt = [NSString stringWithFormat:@"flashDeleteKeyCallBack result: %ld ",(long)result];
    [_recMsgEditTxt setText:txt];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
