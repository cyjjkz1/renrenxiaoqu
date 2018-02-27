//
//  BNPayCenterHomeVC.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayCenterHomeVC.h"
#import "BNNewPayWaysCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "QSWXApiManager.h"
//#import "DataSigner.h"

@interface BNPayCenterHomeVC ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIView *grayBGViewView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UILabel *payWayLbl;
@property (nonatomic) UILabel *payMoneyLbl;
@property (nonatomic, weak) UILabel *goodNumLbl;
@property (nonatomic) UIButton *okButton;

//@property (nonatomic) UILabel *noPswTips;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *payWaysAry;
@property (nonatomic) NSInteger selectRow;
@property (nonatomic) NSString *xiFuSelectCardNoStr;
@property (nonatomic) NSString *couponNumber;
@property (nonatomic) UIButton *couponBtn;
@property (nonatomic,copy) NSString *orderNumber;

@end
@implementation BNPayCenterHomeVC
static CGFloat beginX;
static CGFloat cellHeight;
static CGFloat scrollViewHeight;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.selectRow = 9999;
    self.showNavigationBar = NO;
    self.xiFuSelectCardNoStr = @"";
    
    self.payWaysAry = [@[@{@"card_name" : @"支付宝支付",
                           @"card_no" : @""},
                         @{@"card_name" : @"微信支付",
                           @"card_no" : @""}] mutableCopy];
    self.selectRow = 0;
    scrollViewHeight = 394*BILI_WIDTH;
    
    self.grayBGViewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _grayBGViewView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_grayBGViewView];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, scrollViewHeight)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.frame.size.height);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    UIView *navWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*BILI_WIDTH)];
    navWhiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:navWhiteView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(55*BILI_WIDTH, 0, SCREEN_WIDTH-2*55*BILI_WIDTH, 44*BILI_WIDTH)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    [navWhiteView addSubview:titleLbl];
    titleLbl.font = [UIFont systemFontOfSize:17*BILI_WIDTH];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"订单付款";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 55*BILI_WIDTH, 44*BILI_WIDTH);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [backButton addTarget:self action:@selector(disAppearAnimation) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    [navWhiteView addSubview:backButton];
    
    CGFloat beginY = 44*BILI_WIDTH;
    beginX = 15*BILI_WIDTH;
    cellHeight = 40*BILI_WIDTH;
    
    UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(0, CGRectGetHeight(navWhiteView.frame)-0.5, SCREEN_WIDTH, 0.5)];
    lineView0.backgroundColor = UIColor_GrayLine;
    [navWhiteView addSubview:lineView0];
    
    beginY += (cellHeight-14*BILI_WIDTH)/2;
    
    UILabel *leftLbl0 = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, 14*BILI_WIDTH)];
    leftLbl0.backgroundColor = [UIColor clearColor];
    leftLbl0.textColor = UIColorFromRGB(0x90a4ae);
    leftLbl0.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:leftLbl0];
    leftLbl0.text = @"商品名";
    
    UILabel *goodsNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(74*BILI_WIDTH, beginY, SCREEN_WIDTH-(74+15)*BILI_WIDTH, cellHeight)];
    goodsNumberLbl.backgroundColor = [UIColor clearColor];
    goodsNumberLbl.textColor = [UIColor blackColor];
    goodsNumberLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:goodsNumberLbl];
    goodsNumberLbl.numberOfLines = 0;
    NSString *payType;
//    PayProjectTypeWater,            //水费
//    PayProjectTypeEle,               //电费
//    PayProjectTypeQi,
//    PayProjectTypeWuYe               //物业费
    switch (self.payProjectType) {
        case PayProjectTypeWater:
            payType = @"水费缴纳";
            break;
        case PayProjectTypeEle:
            payType = @"电费缴纳";
            break;
        case PayProjectTypeQi:
            payType = @"气费缴纳";
            break;
        case PayProjectTypeWuYe:
            payType = @"物业费缴纳";
            break;
        default:
            break;
    }

    NSString *goodsName = [NSString stringWithFormat:@"%@元-%@",_amount,payType];
    goodsNumberLbl.text = goodsName;
    CGFloat lblHeight = [Tools caleHeightWithTitle:goodsName font:goodsNumberLbl.font width:goodsNumberLbl.frame.size.width];
    goodsNumberLbl.h = lblHeight;
    _goodNumLbl = goodsNumberLbl;
    
    beginY += lblHeight + (cellHeight-14*BILI_WIDTH)/2;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame: CGRectMake(beginX, beginY-0.5, SCREEN_WIDTH-2*beginX, 0.5)];
    lineView1.backgroundColor = UIColor_GrayLine;
    [_scrollView addSubview:lineView1];
    
    UILabel *leftLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    leftLbl1.backgroundColor = [UIColor clearColor];
    leftLbl1.textColor = UIColorFromRGB(0x90a4ae);
    leftLbl1.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:leftLbl1];
    leftLbl1.text = @"收款方";
    
    UILabel *sellerNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(74*BILI_WIDTH, beginY, SCREEN_WIDTH-74*BILI_WIDTH, cellHeight)];
    sellerNameLbl.backgroundColor = [UIColor clearColor];
    sellerNameLbl.textColor = [UIColor blackColor];
    sellerNameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:sellerNameLbl];
    sellerNameLbl.text = [NSString stringWithFormat:@"%@",@"成都青山物业管理有限公司"];
    
    beginY += sellerNameLbl.frame.size.height;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame: CGRectMake(beginX, beginY-0.5, SCREEN_WIDTH-2*beginX, 0.5)];
    lineView2.backgroundColor = UIColor_GrayLine;
    [_scrollView addSubview:lineView2];
    
    
    UILabel *payWayLbl = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    payWayLbl.backgroundColor = [UIColor clearColor];
    payWayLbl.textColor = UIColorFromRGB(0x90a4ae);
    payWayLbl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [_scrollView addSubview:payWayLbl];
    payWayLbl.text = @"付款方式";
    
    beginY += payWayLbl.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginY, SCREEN_WIDTH, cellHeight*2) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = cellHeight;
    [_tableView registerClass:[BNNewPayWaysCell class] forCellReuseIdentifier:@"BNNewPayWaysCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    
    beginY += _tableView.frame.size.height;
    
    UILabel *payMoneyLeftLbl = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    payMoneyLeftLbl.backgroundColor = [UIColor clearColor];
    payMoneyLeftLbl.textColor = UIColorFromRGB(0x90a4ae);
    payMoneyLeftLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:payMoneyLeftLbl];
    payMoneyLeftLbl.text = @"支付金额";
    
    self.payMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(80*BILI_WIDTH, beginY, SCREEN_WIDTH-(80+15)*BILI_WIDTH, cellHeight)];
    _payMoneyLbl.font = [UIFont boldSystemFontOfSize:14*BILI_WIDTH];
    _payMoneyLbl.textColor = UIColorFromRGB(0xff5252);
    _payMoneyLbl.backgroundColor = [UIColor clearColor];
    _payMoneyLbl.text = [NSString stringWithFormat:@"%@元",self.amount];
    [_scrollView addSubview:_payMoneyLbl];
    
    beginY += payMoneyLeftLbl.frame.size.height;
    
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.tag = 102;
    [_okButton setuporangeBtnTitle:@"确 定" enable:NO];
    _okButton.frame = CGRectMake(15*BILI_WIDTH, beginY, SCREEN_WIDTH-2*15*BILI_WIDTH, 40);
    [_okButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_okButton];
    [self refreshOKBtn];
    
    beginY += _okButton.frame.size.height+20*BILI_WIDTH;
    
    scrollViewHeight = beginY;
    _scrollView.h = scrollViewHeight;
    
    [self appearAnimation];
    
    [self addNotification];
    
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAlipayPayResult) name:kNotification_chargeFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPayCenter) name:kPayCenterDismissNotification object:nil];
}
- (void)dismissPayCenter
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)appearAnimation
{
    _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    [UIView animateWithDuration:0.4 animations:^{
        [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        _scrollView.transform = CGAffineTransformMakeTranslation(0, -scrollViewHeight);
    } completion:^(BOOL finished) {
    }];
}


- (void)disAppearAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self cancelButtonClicked];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addResponseKeyboardAction];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.payWaysAry count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame: CGRectMake(beginX, 0, SCREEN_WIDTH-2*beginX, 0.5)];
    footView.backgroundColor = UIColor_GrayLine;
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNNewPayWaysCell";
    BNNewPayWaysCell *bankCardCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [bankCardCell drawDataWithInfo:_payWaysAry[indexPath.row] selectedRow:_selectRow row:indexPath.row payWayStatus:nil];
    
    return bankCardCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        _selectRow = indexPath.row;
       
        
    } else  {
        //微信支付
        _selectRow = indexPath.row;
    }
    [tableView reloadData];
    [self refreshOKBtn];
}

- (void)refreshOKBtn
{
    if (_selectRow == 0) {
        _okButton.enabled = YES;
    } else if(_selectRow == 1){
        _okButton.enabled = YES;
    }
}
/**
 *  支付方式按钮、确认支付按钮点击事件
 */
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 101: {
            //付款方式按钮
            [self creatPayTrade];
            
            break;
        }
            
        case 102: {
            //确定付款按钮
            if (_selectRow == 0) {
                [self creatPayTrade];
                
            } else if(_selectRow == 1){
                //                [self creatPayTrade];
                [self callWeiXinPayWuYeFeeWithUserId:[UserInfo sharedUserInfo].userId
                                             goodsId:self.orderId
                                             payType:self.payType];
            }
            
            break;
        }
            
    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)networkErrorStoped
{
    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsgWhenPay];
}
- (void)cancelButtonClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(NSString *)URLDecodedString:(NSString *) encodeStr
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodeStr,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (void)requestAlipayPayResult{
    [SVProgressHUD showWithStatus:@"正常查询支付结果..."];
    [RequestApi checkAlipayResult:self.orderNumber
                          success:^(NSDictionary *successData) {
                              [SVProgressHUD dismiss];
                              if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                  [[[UIAlertView alloc] initWithTitle:@"提示" message:@"交费成功" delegate:nil
                                                    cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                              }else{
                                  [[[UIAlertView alloc] initWithTitle:@"提示" message:@"交费失败" delegate:nil
                                                    cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                              }
                              [self dismissPayCenter];
                          } failed:^(NSError *error) {
                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                          }];
}


- (void)creatPayTrade
{
    
    switch (_selectRow) {
        case 0: {//支付宝支付
            [SVProgressHUD showWithStatus:@"请稍候..."];
            [RequestApi getOrderStringWithUserId:[UserInfo sharedUserInfo].userId
                                         goodsId:self.orderId
                                         payType:self.payType
                                         success:^(NSDictionary *successData) {
                                                NSLog(@"orderString---->>>>> %@",successData);
                                                if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                    [SVProgressHUD dismiss];
                                                    NSDictionary *retData = [successData valueNotNullForKey:@"data"];
                                                    NSString *orderStr = [retData valueNotNullForKey:@"payOrderString"];
                                                    self.orderNumber = [retData valueNotNullForKey:@"orderNo"];
                                                    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"communityAlipay" callback:^(NSDictionary *resultDic) {
                                                        NSLog(@"reslut = %@",resultDic);
                                                    }];
                                                }else{
                                                    NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                    [SVProgressHUD showErrorWithStatus:retMsg];
                                                }
                                                
                                            }
                                             failed:^(NSError *error) {
                                                 [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                             }];
            
            /*
             //将商品信息赋予AlixPayOrder的成员变量
             Order* order = [Order new];
             
             // NOTE: app_id设置
             order.app_id = app_id;
             
             // NOTE: 支付接口名称
             order.method = @"alipay.trade.app.pay";
             
             // NOTE: 参数编码格式
             order.charset = @"utf-8";
             
             // NOTE: 当前时间点
             NSDateFormatter* formatter = [NSDateFormatter new];
             [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             order.timestamp = [formatter stringFromDate:[NSDate date]];
             
             // NOTE: 支付版本
             order.version = @"1.0";
             
             // NOTE: sign_type设置
             order.sign_type = @"RSA";
             
             // NOTE: 商品数据
             order.biz_content = [BizContent new];
             order.biz_content.body = @"水费缴纳";
             order.biz_content.subject = @"1";
             order.biz_content.out_trade_no = @"2016101702"; //订单ID（由商家自行制定）
             order.biz_content.timeout_express = @"30m"; //超时时间设置
             order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
             
             
             //将商品信息拼接成字符串
             NSString *orderInfo = [order orderInfoEncoded:NO];
             NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
             
             
             NSLog(@"orderSpec = %@",orderInfo);
             
             // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
             //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
             id<DataSigner> signer = CreateRSADataSigner(privateKey);
             NSString *signedString = [signer signString:orderInfo];
             
             // NOTE: 如果加签成功，则继续执行支付
             if (signedString != nil) {
             //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
             NSString *appScheme = @"communityAlipay";
             
             // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
             NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
             orderInfoEncoded, signedString];
             
             orderInfoEncoded + "&sign=" + signedString
             //                        // NOTE: 调用支付结果开始支付
             [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
             NSLog(@"reslut = %@",resultDic);
             }];
             }
             */
            
        }
        case 1:{
            return;
        }
    }
    
    
    
}

- (void)callWeiXinPayWuYeFeeWithUserId:(NSString *) userId goodsId:(NSString *) goodsId payType:(NSString *)payType
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi weixinPrecreateOrderWithUserId:userId
                                       goodsID:goodsId
                                       payType:payType
                                       success:^(NSDictionary *successData) {
                                           if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                               [SVProgressHUD dismiss];
                                               //请求成功处理
                                               NSDictionary *retData = [successData valueNotNullForKey:@"data"];
                                               if (retData.count > 0) {
                                                   NSDictionary *weixinData = [retData valueNotNullForKey:@"payOrder"];
                                                   [QSWXApiManager sharedManager].orderNumber = [retData valueNotNullForKey:@"orderNo"];
                                                   PayReq *request = [[PayReq alloc] init] ;
                                                   
                                                   request.partnerId = [weixinData valueNotNullForKey:@"partnerid"];
                                                   
                                                   request.prepayId= [weixinData valueNotNullForKey: @"prepayid"];
                                                   
                                                   request.package = [weixinData valueNotNullForKey: @"packageValue"];
                                                   
                                                   request.nonceStr = [weixinData valueNotNullForKey:@"noncestr"];
                                                   
                                                   request.timeStamp = [[weixinData valueNotNullForKey:@"timestamp"] integerValue];
                                                   
                                                   request.sign= [weixinData valueNotNullForKey:@"sign"];
                                                   
                                                   [WXApi sendReq:request];
                                               }
                                           }else{
                                               [SVProgressHUD showErrorWithStatus:@"获取信息异常，请稍后重试"];
                                           }
                                       } failed:^(NSError *error) {
                                           [SVProgressHUD showErrorWithStatus:@"请稍后重试"];
                                       }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:kNotification_chargeFinish];
    [[NSNotificationCenter defaultCenter] removeObserver:kPayCenterDismissNotification];
}
@end
