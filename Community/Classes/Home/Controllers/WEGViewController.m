//
//  WEGViewController.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "WEGViewController.h"
#import "WEGCell.h"
#import "AddNewCardViewController.h"
#import "WEGDetailViewController.h"
#import "WEGChargeVC.h"


@interface WEGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *whiteBGView1;
@property (nonatomic, weak) UILabel *waterInfoLbl;
@property (nonatomic, weak) UILabel *status1;
@property (nonatomic, weak) UILabel *status2;

@property (nonatomic, weak) UIView *whiteBGView2;
@property (nonatomic, weak) UILabel *eleInfoLbl;
@property (nonatomic, weak) UIButton *chargeBtn;

@property (nonatomic, strong) NSDictionary *datas;

@end



@implementation WEGViewController

static NSString *const WEGCellID = @"WEGCellID";


- (void)setUseType:(WEGVCUseType)useType
{
    _useType = useType;
    self.navigationTitle = useType == WEGVCUseTypeWaterElecGas ? @"水电" : @"物业费";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.telManagerBtn.hidden = NO;
   
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self wegInfo];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    
    
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    
    UIView *whiteBGView1 = [[UIView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 13 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, 88.5*BILI_WIDTH)];
    whiteBGView1.backgroundColor = [UIColor whiteColor];
    whiteBGView1.layer.cornerRadius = 4 * BILI_WIDTH;
    [self.baseScrollView addSubview:whiteBGView1];
    _whiteBGView1 = whiteBGView1;
    
    
    UIImageView *waterImg = [[UIImageView alloc] initWithFrame:CGRectMake(17 * BILI_WIDTH, 19 * BILI_WIDTH, 58 * BILI_WIDTH, 48 * BILI_WIDTH)];
    NSString *imageName = _useType == WEGVCUseTypeWaterElecGas ? @"water_card" : @"wuye";
    waterImg.image = [UIImage imageNamed:imageName];
    [whiteBGView1 addSubview:waterImg];
    
    UIColor *tempColor = UIColorFromRGB(0xa8a8a8);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(waterImg.maxX + 15 * BILI_WIDTH, 25 * BILI_WIDTH, 183 * BILI_WIDTH, 13 * BILI_WIDTH)];
    nameLabel.text = _useType == WEGVCUseTypeWaterElecGas ? @"上月用水信息" : @"上月物业费";
    nameLabel.textColor = tempColor;
    nameLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView1 addSubview:nameLabel];
    
    UILabel *waterInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(waterImg.maxX + 15 * BILI_WIDTH, nameLabel.maxY + 13*BILI_WIDTH, 200 * BILI_WIDTH, 13 * BILI_WIDTH)];
    waterInfoLbl.text = _useType == WEGVCUseTypeWaterElecGas ? @"用量:_ _  应缴:_ _" : @"应缴:_ _";
    waterInfoLbl.textColor = tempColor;
    waterInfoLbl.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView1 addSubview:waterInfoLbl];
    _waterInfoLbl = waterInfoLbl;
    
    UILabel *charge1 = [[UILabel alloc] initWithFrame:CGRectMake(whiteBGView1.w - 60, 0, 50, 20)];
    charge1.centerY = waterInfoLbl.centerY;
    charge1.backgroundColor = BNColorRGB(255, 151, 0);;
    charge1.text = @"状态";
    charge1.textColor = [UIColor whiteColor];
    charge1.layer.cornerRadius = 4;
    charge1.layer.masksToBounds = YES;
    charge1.textAlignment = NSTextAlignmentCenter;
    charge1.font = [UIFont systemFontOfSize:12];
    [whiteBGView1 addSubview:charge1];
    _status1 = charge1;
    
    CGFloat chargeBtnStartY = whiteBGView1.maxY + 13 * BILI_WIDTH;
    
    if(self.useType == WEGVCUseTypeWaterElecGas){
        UIView *whiteBGView2 = [[UIView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, whiteBGView1.maxY + 13 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, 88.5*BILI_WIDTH)];
        whiteBGView2.backgroundColor = [UIColor whiteColor];
        whiteBGView2.layer.cornerRadius = 4 * BILI_WIDTH;
        [self.baseScrollView addSubview:whiteBGView2];
        whiteBGView2 = whiteBGView2;
    
        
        UIImageView *eleImg = [[UIImageView alloc] initWithFrame:CGRectMake(17 * BILI_WIDTH, 19 * BILI_WIDTH, 58 * BILI_WIDTH, 48 * BILI_WIDTH)];
        eleImg.image = [UIImage imageNamed:@"electric_card"];
        [whiteBGView2 addSubview:eleImg];
        
        
        UILabel *nameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(eleImg.maxX + 15 * BILI_WIDTH, 25 * BILI_WIDTH, 183 * BILI_WIDTH, 13 * BILI_WIDTH)];
        nameLabel2.text = @"上月用电信息";
        nameLabel2.textColor = tempColor;
        nameLabel2.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
        [whiteBGView2 addSubview:nameLabel2];
        
        UILabel *eleInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(eleImg.maxX + 15 * BILI_WIDTH, nameLabel2.maxY + 13*BILI_WIDTH, 200 * BILI_WIDTH, 13 * BILI_WIDTH)];
        eleInfoLbl.text = @"用量:_ _  应缴:_ _";
        eleInfoLbl.textColor = tempColor;
        eleInfoLbl.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
        [whiteBGView2 addSubview:eleInfoLbl];
        _eleInfoLbl = eleInfoLbl;
        
        
        UILabel *charge2 = [[UILabel alloc] initWithFrame:CGRectMake(whiteBGView1.w - 60, 0, 50, 20)];
        charge2.centerY = eleInfoLbl.centerY;
        charge2.backgroundColor = BNColorRGB(255, 151, 0);
        charge2.text = @"缴费";
        charge2.textColor = [UIColor whiteColor];
        charge2.layer.cornerRadius = 4;
        charge2.layer.masksToBounds = YES;
        charge2.textAlignment = NSTextAlignmentCenter;
        charge2.font = [UIFont systemFontOfSize:12];
        [whiteBGView2 addSubview:charge2];
        _status2 = charge2;
        
        chargeBtnStartY = whiteBGView2.maxY + 13 * BILI_WIDTH;
    }
    
    UIButton *chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chargeBtn.frame = CGRectMake(whiteBGView1.x, chargeBtnStartY, whiteBGView1.w, 40);
    [chargeBtn setuporangeBtnTitle:@"缴 费" enable:NO];
    [chargeBtn addTarget:self action:@selector(chargeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:chargeBtn];
    _chargeBtn = chargeBtn;
    
    
//    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72 * BILI_WIDTH)];
//    tableFooterView.backgroundColor = UIColorFromRGB(0xf3f3f3);
//    NSString *btnTitle =  _useType == WEGVCUseTypeWaterElecGas ? @"绑定新卡" : @"绑定新用户";
//    UIButton *addNew = [UIButton buttonWithType:UIButtonTypeCustom];
//    addNew.frame = CGRectMake(13 * BILI_WIDTH, 19 * BILI_WIDTH, SCREEN_WIDTH - 26 * BILI_WIDTH, 34 * BILI_WIDTH);
//    [addNew setuporangeBtnTitle:btnTitle enable:YES];
//    addNew.layer.cornerRadius = 4 * BILI_WIDTH;
//    addNew.layer.masksToBounds = YES;
//    [addNew addTarget:self action:@selector(addNewCardAction) forControlEvents:UIControlEventTouchUpInside];
//    [tableFooterView addSubview:addNew];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEGCell *cell = [tableView dequeueReusableCellWithIdentifier:WEGCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WEGDetailViewController *detailVC = [[WEGDetailViewController alloc] init];
    [self pushViewController:detailVC animated:YES];
}

//- (void)addNewCardAction
//{
//    AddNewCardViewController *addVC = [[AddNewCardViewController alloc] init];
//    addVC.useType = _useType == WEGVCUseTypeWaterElecGas ? AddNewCardVCUseTypeAddWEG : AddNewCardVCUseTypeAddNewUser;
//    [self pushViewController:addVC animated:YES];
//}


#pragma mark -Request

- (void)wegInfo
{
    NSString *userId = [UserInfo sharedUserInfo].userId;
    __weak typeof(self) weakSelf = self;

    if (_useType == WEGVCUseTypeWaterElecGas) {
        //水电
        [SVProgressHUD showWithStatus:@"请稍后..."];
        [RequestApi get_electricalAndWaterInfoWithUserId:userId
                                                 success:^(NSDictionary *successData) {
                                                     NSLog(@"水电气信息---->>>>%@",successData);
                                                     if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                         [SVProgressHUD dismiss];
                                                         
                                                         id returnData = [successData valueNotNullForKey:@"data"];
                                                         if (![successData.allKeys containsObject:@"data"]  || ([returnData isKindOfClass:[NSString class]] && [returnData isEqualToString:@"null"])) {
                                                             //没有信息
                                                             //donothing
                                                             
                                                         }else{
                                                             NSDictionary *data = [successData valueNotNullForKey:@"data"];
                                                             weakSelf.datas = [[NSDictionary alloc] initWithDictionary:data];
                                                         }
                                                         
                                                        
                                                         
//                                                         data = @{
//                                                                                @"id":@"216",
//                                                                                @"waterFee": @0.01,
//                                                                                @"waterUsed": @9,
//                                                                                @"electricalFee": @0.01,
//                                                                                @"electricalUsed": @83,
//                                                                                @"createTime": @1468064110000,
//                                                                                @"buildingName": @"四栋一单",
//                                                                                @"roomName": @"111",
//                                                                                @"importDate": @"2016年07月",
//                                                                                @"status": @1
//                                                                                };
                                                         
                                                         
                                                         [weakSelf setupStatisticsData];
                                                         
                                                     }else{
                                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                     }
                                                     
                                                 } failed:^(NSError *error) {
                                                     NSLog(@"%@",error);
                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                 }];
        
    }else{
        //物业费
        [SVProgressHUD showWithStatus:@"请稍后..."];
        [RequestApi get_wuYeFeesWithUserId:userId success:^(NSDictionary *successData) {
            NSLog(@"物业费信息---->>>>%@",successData);
            if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [SVProgressHUD dismiss];
                
                
                id returnData = [successData valueNotNullForKey:@"data"];
                if (![successData.allKeys containsObject:@"data"]  || ([returnData isKindOfClass:[NSString class]] && [returnData isEqualToString:@"null"])) {
                    //没有信息
                    //donothing
                    
                }else{
                    NSDictionary *data = [successData valueNotNullForKey:@"data"];
                    weakSelf.datas = [[NSDictionary alloc] initWithDictionary:data];
                }
                
//                data = @{
//                         @"id" : @"1",
//                         @"endDate" : @"1478361600000",
//                         @"createTime" : @"1477359379000",
//                         @"amount" : @"59",
//                         @"roomName" : @"101",
//                         @"status" : @"1",
//                         @"startDate" : @"1475510400000",
//                         @"buildingName" : @"四栋一单元",
//                         @"importDate" : @"2016年10月"
//                         };
//  
                
                [weakSelf setupWuYeStatisticsData];
                
            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }

        } failed:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];

    }
}

// 设置水电数据
- (void)setupStatisticsData
{
    if (!self.datas || self.datas.count == 0) {
        _waterInfoLbl.text = @"尚未统计";
        _eleInfoLbl.text = @"尚未统计";
        _status1.hidden = YES;
        _status2.hidden = YES;
        _chargeBtn.enabled = NO;
    }else{
        NSString *status = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"status"]];
        [self setupStatusLabelWithSatus:status label:_status1];
        [self setupStatusLabelWithSatus:status label:_status2];
        
        NSString *waterFes = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"waterFee"]];
        NSString *waterUsed = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"waterUsed"]];
        
        NSString *str1 = [NSString stringWithFormat:@"用量:%@吨  应缴:%@元",waterUsed, waterFes];
        NSMutableAttributedString *waterAtts = [[NSMutableAttributedString alloc] initWithString:str1];
        [waterAtts setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(str1.length - 1 - waterFes.length, waterFes.length)];
        
        _waterInfoLbl.attributedText = waterAtts;
        
        NSString *electricalFee = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"electricalFee"]];
        NSString *electricalUsed = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"electricalUsed"]];
        
        NSString *str2 = [NSString stringWithFormat:@"用量:%@度  应缴:%@元",electricalUsed, electricalFee];
        NSMutableAttributedString *eleAtts = [[NSMutableAttributedString alloc] initWithString:str2];
        [eleAtts setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(str2.length - 1 - electricalFee.length, electricalFee.length)];
        
        _eleInfoLbl.attributedText = eleAtts;;
        
    }
}

//设置物业数据
- (void)setupWuYeStatisticsData
{
    if (!self.datas || self.datas.count == 0) {
        _waterInfoLbl.text = @"尚未统计";
        _status1.hidden = YES;
    }else{
        
        NSString *status = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"status"]];
        [self setupStatusLabelWithSatus:status label:_status1];
        
        NSString *wuYeFees = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"amount"]];
        NSString *str = [NSString stringWithFormat:@"应缴:%@元",wuYeFees];
        
        NSMutableAttributedString *matts = [[NSMutableAttributedString alloc] initWithString:str];
        [matts setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(str.length - 1 - wuYeFees.length, wuYeFees.length)];
//
        _waterInfoLbl.attributedText = matts;

    }
    
}


- (void)setupStatusLabelWithSatus:(NSString *)status label:(UILabel *)label
{
    switch (status.integerValue) {
        case 0:
        {
            //过期
            label.text = @"已过期";
            label.backgroundColor = [UIColor lightGrayColor];
            _chargeBtn.enabled = NO;
        }
            break;
        case 1:
        {
            //可缴纳
            label.text = @"可缴纳";
            label.backgroundColor = BNColorRGB(255, 151, 0);
            _chargeBtn.enabled = YES;
        }
            break;
        case 4:
        {
            //处理中
            label.text = @"处理中";
            label.backgroundColor = [UIColor lightGrayColor];
            _chargeBtn.enabled = NO;
        }
            break;
        case 5:
        {
            //已缴纳
            label.text = @"已缴纳";
            label.backgroundColor = [UIColor greenColor];
            _chargeBtn.enabled = NO;
            
        }
            
        default:
            break;
    }
}

#pragma mark - Recharge

- (void)chargeAction
{
    float chargeAomut = 0.0;
    WEGChargeVCUseType chargeType;
    if (self.useType == WEGChargeVCUseTypeWaterEle) {
        NSString *waterFes = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"waterFee"]];
        NSString *electricalFee = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"electricalFee"]];
        chargeAomut = waterFes.floatValue + electricalFee.floatValue;
        chargeType = WEGChargeVCUseTypeWaterEle;
    }else{
        NSString *wuYeFees = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"amount"]];
        chargeAomut = wuYeFees.floatValue;
        chargeType = WEGChargeVCUseTypeWuYe;
    }
    WEGChargeVC * chargeVc = [[WEGChargeVC alloc] init];
    chargeVc.amount = [NSString stringWithFormat:@"%.2f",chargeAomut];
    chargeVc.orderId = [NSString stringWithFormat:@"%@",[self.datas valueNotNullForKey:@"id"]];
    chargeVc.chargeType = chargeType;
    [self pushViewController:chargeVc animated:YES];

}

/*
//水费充值
- (void)waterChargeAction
{

    if (self.datas.count == 0|| [dic isKindOfClass:[NSString class]]) {
        [SVProgressHUD showErrorWithStatus:@"您暂无缴费项目"];
        return;
    }
    
    NSString *waterFes = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"waterFee"]];
    WEGChargeVC * chargeVc = [[WEGChargeVC alloc] init];
    chargeVc.amount = waterFes;
    chargeVc.chargeType = WEGChargeVCUseTypeWater;
    [self pushViewController:chargeVc animated:YES];
}

//电费充值
- (void)eleChargeAction
{
    NSDictionary *dic = self.datas[0];
    if (self.datas.count == 0|| [dic isKindOfClass:[NSString class]]) {
        [SVProgressHUD showErrorWithStatus:@"您暂无缴费项目"];
        return;
    }
    NSString *electricalFee = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"electricalFee"]];
    WEGChargeVC * chargeVc = [[WEGChargeVC alloc] init];
    chargeVc.chargeType = WEGChargeVCUseTypeEle;
     chargeVc.amount = electricalFee;
    [self pushViewController:chargeVc animated:YES];
}

- (void)wuyeFeesChargeAction
{
    NSDictionary *dic = self.datas[0];
    if (self.datas.count == 0|| [dic isKindOfClass:[NSString class]]) {
        [SVProgressHUD showErrorWithStatus:@"您暂无缴费项目"];
        return;
    }
    
    NSString *wuYeFees = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"amount"]];
    
    WEGChargeVC * chargeVc = [[WEGChargeVC alloc] init];
    chargeVc.chargeType = WEGChargeVCUseTypeWuYe;
    chargeVc.amount = wuYeFees;
    [self pushViewController:chargeVc animated:YES];
    
}
 */


@end
