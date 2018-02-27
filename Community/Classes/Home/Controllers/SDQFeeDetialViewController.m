//
//  SDQFeeDetialViewController.m
//  Community_http
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "SDQFeeDetialViewController.h"
#import "cc_macro.h"
#import "RequestApi.h"
#import "QSWXApiManager.h"
#import "BNPayCenterHomeVC.h"

@interface SDQFeeDetialViewController ()<UIActionSheetDelegate>
@property (nonatomic,weak) UILabel *amountLab;
@property (nonatomic,weak) UILabel *statusLab;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UILabel *importTimeLab;
@property (nonatomic,weak) UIButton *goPayBtn;
@property (nonatomic,strong) NSDictionary *jiaoFeeInfoDict;

@end

@implementation SDQFeeDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotification];
    switch (self.userType) {
        case SDQFeeDetialShui:
            self.navigationTitle = @"缴水费";
            break;
        case SDQFeeDetialDian:
            self.navigationTitle = @"缴电费";
            break;
        case SDQFeeDetialQi:
            self.navigationTitle = @"缴气费";
            break;
        case SDQFeeDetialWuye:
            self.navigationTitle = @"缴物业费";
            break;
            
        default:
            break;
    }
    self.telManagerBtn.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    theScrollView.contentSize = CGSizeMake(theScrollView.w, SCREEN_HEIGHT - NaviHeight + 1);
    theScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        theScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    theScrollView.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.view addSubview:theScrollView];
    
    UIImageView *detialBGView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16 * BILI_WIDTH, SCREEN_WIDTH - 30, 252 * BILI_WIDTH)];
    detialBGView.userInteractionEnabled = YES;
    [detialBGView setImage:[UIImage imageNamed:@"icon_fee_bgimage"]];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:detialBGView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = detialBGView.bounds;
    maskLayer.path = maskPath.CGPath;
    detialBGView.layer.mask = maskLayer;
    [theScrollView addSubview:detialBGView];
    
    UILabel *amountLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 * BILI_WIDTH, detialBGView.w - 40, 40 * BILI_WIDTH)];
    amountLb.textColor = UIColorFromRGB(0x0080ff);
    amountLb.text = @"0.00";
    amountLb.font = [UIFont boldSystemFontOfSize:30 * BILI_WIDTH];
    amountLb.textAlignment = NSTextAlignmentCenter;
    [detialBGView addSubview:amountLb];
    
    UILabel *danweiLb = [[UILabel alloc] initWithFrame:CGRectMake(20, amountLb.maxY, detialBGView.w - 40, 20 * BILI_WIDTH)];
    danweiLb.textColor = [UIColor lightGrayColor];
    danweiLb.text = @"(缴费)元";
    danweiLb.font = [UIFont boldSystemFontOfSize:13 * BILI_WIDTH];
    danweiLb.textAlignment = NSTextAlignmentCenter;
    [detialBGView addSubview:danweiLb];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, danweiLb.maxY + 15 * BILI_WIDTH, detialBGView.w - 30, 0.5)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, line1.maxY + 50 * BILI_WIDTH, detialBGView.w - 30, 0.5)];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, line2.maxY + 50 * BILI_WIDTH, detialBGView.w - 30, 0.5)];
    line1.backgroundColor = UIColorFromRGB(0xe2e2e2);
    line2.backgroundColor = UIColorFromRGB(0xe2e2e2);
    line3.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [detialBGView addSubview:line1];
    [detialBGView addSubview:line2];
    [detialBGView addSubview:line3];
    
    UILabel *jiaoFeeTitle = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line1.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    UILabel *xiaoquNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line2.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line3.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    jiaoFeeTitle.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    xiaoquNameTitle.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    timeTitle.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    
    jiaoFeeTitle.textAlignment = NSTextAlignmentLeft;
    xiaoquNameTitle.textAlignment = NSTextAlignmentLeft;
    timeTitle.textAlignment = NSTextAlignmentLeft;
    
    jiaoFeeTitle.textColor = [UIColor lightGrayColor];
    xiaoquNameTitle.textColor = [UIColor lightGrayColor];
    timeTitle.textColor = [UIColor lightGrayColor];
    
    jiaoFeeTitle.text = @"交费状态";
    xiaoquNameTitle.text = @"小区名称";
    timeTitle.text = @"导入时间";
    [detialBGView addSubview:jiaoFeeTitle];
    [detialBGView addSubview:xiaoquNameTitle];
    [detialBGView addSubview:timeTitle];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line1.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line2.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.x, line3.maxY+1, line1.w, 50 * BILI_WIDTH - 1)];
    statusLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    nameLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    timeLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    
    statusLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    statusLabel.textColor = [UIColor lightGrayColor];
    nameLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textColor = [UIColor lightGrayColor];
    
    statusLabel.text = @"状态未知";
    nameLabel.text = @"--";
    timeLabel.text = @"--";
    [detialBGView addSubview:statusLabel];
    [detialBGView addSubview:nameLabel];
    [detialBGView addSubview:timeLabel];
    
    
    UIButton *payFeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payFeeBtn.frame = CGRectMake(60 , detialBGView.maxY + 20 * BILI_WIDTH, SCREEN_WIDTH - 120 , 40 * BILI_WIDTH);
    payFeeBtn.layer.cornerRadius = 20 * BILI_WIDTH;
    [payFeeBtn setuporangeBtnTitle:@"缴费" enable:NO];
    [payFeeBtn addTarget:self action:@selector(payFeeAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:payFeeBtn];
    
    self.amountLab = amountLb;
    self.statusLab = statusLabel;
    self.nameLab = nameLabel;
    self.importTimeLab = timeLabel;
    self.goPayBtn = payFeeBtn;
    
    [self requestFeeStatus];
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFeeStatus) name:kWeiXinPayResultNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFeeStatus) name:kNotification_chargeFinish object:nil];
}

- (void)requestFeeStatus{
    switch (self.userType) {
        case SDQFeeDetialShui:
        {
            [self requestShuiDianFee];
        }
            break;
        case SDQFeeDetialDian:
        {
            [self requestShuiDianFee];
        }
            break;
        case SDQFeeDetialQi:
        {
        }
            break;
        case SDQFeeDetialWuye:
        {
            [self requestWuYeFee];
        }
            break;
        default:
            break;
    }
}
- (void)requestShuiDianFee{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi get_electricalAndWaterInfoWithUserId: [UserInfo sharedUserInfo].userId
                                             success:^(NSDictionary *successData) {
                                                 if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                     [SVProgressHUD dismiss];
                                                     //请求成功处理
                                                     id dicData = successData[@"data"];
                                                     if(![dicData isKindOfClass:[NSDictionary class]]){
                                                         if(self.userType == SDQFeeDetialShui){
                                                             [SVProgressHUD showErrorWithStatus:@"暂无水费信息，请稍后继续关注"];

                                                         }else if(self.userType == SDQFeeDetialDian){
                                                             [SVProgressHUD showErrorWithStatus:@"暂无电费信息，请稍后继续关注"];

                                                         }
                                                         return;
                                                     }
                                                     NSDictionary *retData = (NSDictionary *)dicData;
                                                     if (retData.count > 0) {
                                                         self.jiaoFeeInfoDict = [retData copy];
                                                         NSString *amount = @"";
                                                         NSString *status = @"";
                                                         NSString *importDate = [retData[@"importDate"] description];
                                                         NSString *roomName = [retData[@"roomName"] description];
                                                         
                                                         if(self.userType == SDQFeeDetialShui){
                                                             amount = [retData[@"waterFee"] description];
                                                             status = [self statusDescriptionWithId:[retData[@"waterStatus"] description]];
                                                         }else if(self.userType == SDQFeeDetialDian){
                                                             amount = [retData[@"electricalFee"] description];
                                                             status = [self statusDescriptionWithId:[retData[@"electricalStatus"] description]];
                                                         }
                                                         self.amountLab.text = amount;
                                                         self.statusLab.text = status;
                                                         self.nameLab.text = roomName;
                                                         self.importTimeLab.text = importDate;
                                                     }else{
                                                        [SVProgressHUD showErrorWithStatus:@"获取信息异常，请稍后重试"];
                                                     }
                                                 }else{
                                                     [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                                 }
                                              }
                                              failed:^(NSError *error) {
                                                 [SVProgressHUD showErrorWithStatus:@"稍后重试"];
                                              }];
}

- (NSString *)statusDescriptionWithId:(NSString *)statusId
{
    NSString *status = @"";
    if ([statusId isEqualToString:@"1"]) {
        status = @"未交费";
        self.goPayBtn.enabled = YES;
    }else if([statusId isEqualToString:@"5"]){
        status = @"已缴费";
        self.goPayBtn.enabled = NO;
    }else if([statusId isEqualToString:@"4"]){
        status = @"交费处理中";
        self.goPayBtn.enabled = NO;
    }else {
        status = @"--";
        self.goPayBtn.enabled = NO;
    }
    return status;
}
- (void)requestWuYeFee
{
    //保存到单例类
    UserInfo *user = [UserInfo sharedUserInfo];
    
    [RequestApi get_wuYeFeesWithUserId:user.userId success:^(NSDictionary *successData) {
        if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            //请求成功处理
            id dicData = successData[@"data"];
            if(![dicData isKindOfClass:[NSDictionary class]]){
                [SVProgressHUD showErrorWithStatus:@"暂无物业费信息，请稍后继续关注"];
                return;
            }
            NSDictionary *retData = (NSDictionary *)dicData;
            if (retData.count > 0) {
                NSString *amount = [retData[@"amount"] description];
                NSString *status = [retData[@"status"] description];
                NSString *importDate = [retData[@"importDate"] description];
                NSString *roomName = [retData[@"roomName"] description];
                if ([status isEqualToString:@"1"]) {
                    status = @"未交费";
                    self.goPayBtn.enabled = YES;
                }else if([status isEqualToString:@"5"]){
                    status = @"已缴费";
                    self.goPayBtn.enabled = NO;
                }else if([status isEqualToString:@"4"]){
                    status = @"交费处理中";
                    self.goPayBtn.enabled = NO;
                }else {
                    status = @"--";
                    self.goPayBtn.enabled = NO;
                }
                self.jiaoFeeInfoDict = [retData copy];
                
                self.amountLab.text = amount;
                self.statusLab.text = status;
                self.nameLab.text = roomName;
                self.importTimeLab.text = importDate;
            }else{
                [SVProgressHUD showErrorWithStatus:@"获取信息异常，请稍后重试"];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
        }
        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"稍后重试"];
    }];
}
- (void)payFeeAcion:(UIButton *)btn
{
    BNPayCenterHomeVC *payVC = [[BNPayCenterHomeVC alloc] init];
    switch (self.userType) {
        case SDQFeeDetialShui:
        {
            payVC.payProjectType = PayProjectTypeWater;
            payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
                //        returnBlock(jumpType, params);
            };
            payVC.amount = [self.jiaoFeeInfoDict[@"waterFee"] description];
            payVC.orderId = [self.jiaoFeeInfoDict[@"id"] description];
            payVC.payType = @"1";
        }
            break;
        case SDQFeeDetialDian:
        {
            
            payVC.payProjectType = PayProjectTypeEle;
            payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
                //        returnBlock(jumpType, params);
            };
            payVC.amount = [self.jiaoFeeInfoDict[@"electricalFee"] description];
            payVC.orderId = [self.jiaoFeeInfoDict[@"id"] description];
            payVC.payType = @"2";
        }
            break;
        case SDQFeeDetialQi:
        {
            
        }
            break;
        case SDQFeeDetialWuye:
        {
            payVC.payProjectType = PayProjectTypeWuYe;
            payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
                //        returnBlock(jumpType, params);
            };
            payVC.amount = [self.jiaoFeeInfoDict[@"amount"] description];
            payVC.orderId = [self.jiaoFeeInfoDict[@"id"] description];
            payVC.payType = @"4";
            break;
        }
        default:
            break;
    }
            
    self.navigationController.definesPresentationContext = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    nav.navigationBarHidden = YES;
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:kWeiXinPayResultNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotification_chargeFinish];
}
@end
