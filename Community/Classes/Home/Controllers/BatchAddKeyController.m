//
//  BatchAddKeyController.m
//  BLKApp
//
//  Created by roryyang on 16/8/17.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import "BatchAddKeyController.h"

@interface BatchAddKeyController ()

@property (nonatomic,retain) UITextField* cardNoTxtFile;
@property (nonatomic,retain) UITextField* cardCountTxtFile;
@property (nonatomic,retain) UILabel* spentTimeTxtView;
@property (nonatomic,retain)UIButton* openBtn;
@property (nonatomic,retain)UIButton* delOneCardBtn;
@property (nonatomic,retain)UIButton* delAllCardBtn;

@property (nonatomic, assign) UInt32 currentItemIndex;
@property (nonatomic, assign) UInt32 itemCount;
@property (nonatomic, assign) UInt32 itenNumPerTime;
@property (nonatomic, assign) UInt32 frameWidth;
@property (nonatomic, assign) UInt32 frameHeight;
@property (nonatomic, assign) UInt32 padding;
@property (nonatomic, assign) UInt32 margining;
@property (nonatomic, assign) UInt32 viewHeight;

@property (nonatomic, assign) UInt32 startTime;

@end

@implementation BatchAddKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self addGesture];
    _myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    _myscrollview.directionalLockEnabled = YES; //只能一个方向滑动
    _myscrollview.pagingEnabled = NO; //是否翻页
    _myscrollview.backgroundColor= [UIColor whiteColor];
    _myscrollview.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _myscrollview.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动指示的风格
    _myscrollview.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _myscrollview.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    [_myscrollview setContentSize:newSize];
    
    //startCardNo
    UILabel* cardNoTxtView = [[UILabel alloc] initWithFrame:CGRectMake(_margining, _margining, _frameWidth/2-_margining, _viewHeight)];
    _cardNoTxtFile = [[UITextField alloc]initWithFrame:CGRectMake(_frameWidth/2+_margining, _margining, _frameWidth/2-_margining, _viewHeight)];
    _cardCountTxtFile= [[UITextField alloc]initWithFrame:CGRectMake(_frameWidth/2+_margining, _viewHeight+_margining*2, _frameWidth/2-_margining, _viewHeight)];
    UILabel*  cardCountTxtView= [[UILabel alloc]initWithFrame:CGRectMake(_margining, _viewHeight+_margining*2, _frameWidth/2-_margining, _viewHeight)];
    _spentTimeTxtView = [[UILabel alloc]initWithFrame:CGRectMake(_margining, _viewHeight*2+_margining*3, _frameWidth, _viewHeight)];
    
    _cardNoTxtFile.layer.borderWidth = 1;
    _cardNoTxtFile.layer.borderColor = [[UIColor grayColor] CGColor];
    _cardNoTxtFile.layer.cornerRadius = 8;
    _cardNoTxtFile.layer.masksToBounds = YES;
    _cardCountTxtFile.layer.borderWidth = 1;
    _cardCountTxtFile.layer.borderColor = [[UIColor grayColor] CGColor];
    _cardCountTxtFile.layer.cornerRadius = 8;
    _cardCountTxtFile.layer.masksToBounds = YES;
    
    
    [ _cardNoTxtFile setText:@"458D51F9"];
    [_cardCountTxtFile setText:@"100"];
    [cardNoTxtView setText:@"卡号"];
    [cardCountTxtView setText:@"累计发卡"];
    
    
    [_myscrollview addSubview:cardNoTxtView];
    [_myscrollview addSubview:_cardNoTxtFile];
    [_myscrollview addSubview:cardCountTxtView];
    [_myscrollview addSubview:_cardCountTxtFile];
    [_myscrollview addSubview:_spentTimeTxtView];
    
    _openBtn = [[UIButton alloc]initWithFrame:CGRectMake(_margining, _viewHeight*3+_margining*4, _frameWidth, _viewHeight)];
    
    _openBtn.backgroundColor = [UIColor grayColor];
    [_openBtn addTarget:self action:@selector(dispatchCardSensor) forControlEvents:UIControlEventTouchUpInside];
    [_openBtn setTitle:@"发卡" forState:UIControlStateNormal];
    [_openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myscrollview addSubview:_openBtn];
    
    _delOneCardBtn = [[UIButton alloc]initWithFrame:CGRectMake(_margining, _viewHeight*4+_margining*5, _frameWidth/2-_margining*2, _viewHeight)];
    _delAllCardBtn = [[UIButton alloc]initWithFrame:CGRectMake(_margining+_frameWidth/2, _viewHeight*4+_margining*5, _frameWidth/2-_margining*2, _viewHeight)];
    [_delOneCardBtn setTitle:@"删单张卡" forState:UIControlStateNormal];
    [_delOneCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_delAllCardBtn setTitle:@"清除所有卡" forState:UIControlStateNormal];
    [_delAllCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _delOneCardBtn.backgroundColor = [UIColor grayColor];
    [_delOneCardBtn addTarget:self action:@selector(clearOneCard) forControlEvents:UIControlEventTouchUpInside];
    
    _delAllCardBtn.backgroundColor = [UIColor grayColor];
    [_delAllCardBtn addTarget:self action:@selector(clearAllCard) forControlEvents:UIControlEventTouchUpInside];
    
    [_myscrollview addSubview:_delOneCardBtn];
    [_myscrollview addSubview:_delAllCardBtn];
    
    //card count
    
    [self.view addSubview:_myscrollview];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    _sensor = [DHBle shareInstance];
    _sensor.delegate = self;
    _peripheral = _sensor.activePeripheral;
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

-(void) initData{
    _currentItemIndex = 0;
    _itemCount = 0;
    _itenNumPerTime = 2;
    _frameWidth = 300;//self.view.frame.size.width;
    _frameHeight = self.view.frame.size.height;
    _padding = 15;
    _margining = 15;
    _viewHeight = 40;
    
    _sensor = [DHBle shareInstance];
    _sensor.delegate = self;
    _peripheral = _sensor.activePeripheral;
}

-(void) dispatchCardSensor{
    _currentItemIndex = 0;
    _itemCount = [_cardCountTxtFile.text intValue];
    _startTime = [[NSDate date] timeIntervalSince1970];
    [self dispatchCard];
    
}

-(void)clearOneCard{
    NSString* psw = @"12345678";
    NSString* keyId = _cardNoTxtFile.text;
    [_sensor oneKeyFlashDeleteKey:self.peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:psw type:3 delKeyId:keyId];
}

-(void)clearAllCard{
    NSString* psw = @"12345678";
    NSString* keyId = @"00000000";
    [_sensor oneKeyFlashDeleteKey:self.peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:psw type:3 delKeyId:keyId];
}

-(void)dispatchCard{
    NSString* psw = @"12345678";
    UInt32 key1,key2;
    NSArray* keyList = nil;
    NSArray* dateList = nil;
    //_itenNumPerTime max value is 2;
    if(_itenNumPerTime == 1){
        key1 = [_sensor stringToUInt32:_cardNoTxtFile.text] + _currentItemIndex;
        keyList = [NSArray arrayWithObjects:[_sensor uInt32ToString:key1],nil];
        dateList = [NSArray arrayWithObjects:[NSDate date] ,nil];
    }else if(_itenNumPerTime == 2){
        
        key1 = [_sensor stringToUInt32:_cardNoTxtFile.text] + _currentItemIndex;
        key2 = [_sensor stringToUInt32:_cardNoTxtFile.text] + _currentItemIndex+1;
        
        keyList = [NSArray arrayWithObjects:[_sensor uInt32ToString:key1],[_sensor uInt32ToString:key2],nil];
        dateList = [NSArray arrayWithObjects:[NSDate date],[NSDate date] ,nil];
    }
    
    [_sensor oneKeyFlashAddKey:self.peripheral deviceNum:[_sensor getDeviceIdForStringValue:_peripheral] devicePassword:psw type:3 addKeyIdList:keyList addActiveDateList:dateList];
}

- (void)flashAddKeyCallBack:(DHBleResultType) result{
    if(DHBLE_ER_OK == result){
        _currentItemIndex +=_itenNumPerTime;
        UInt32 disTime = [[NSDate date] timeIntervalSince1970] - _startTime;
        [_spentTimeTxtView setText:[NSString stringWithFormat:@"spent: %d 秒 hasDisPath: %d/%d ",disTime,_currentItemIndex,_itemCount]];
        if(_currentItemIndex >= _itemCount){
            NSLog(@"Batch Add Card Success.");
            return;
        }
        [self dispatchCard];
    }
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
