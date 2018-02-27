//
//  SDQViewController.m
//  Community_http
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "SDQViewController.h"
#import "SDQFeeDetialViewController.h"
#import "cc_macro.h"
@interface SDQViewController ()

@property (nonatomic, weak) UILabel  *shuiDetialLabel;
@property (nonatomic, weak) UILabel  *dianDetialLabel;
@property (nonatomic, strong) NSDictionary *shuiDianFeeInfoDict;
@end

@implementation SDQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    self.navigationTitle = @"水电";
    UIImageView *shuiCardView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16 * BILI_WIDTH, SCREEN_WIDTH - 30, 100 * BILI_WIDTH)];
    UIImageView * dianCardView = [[UIImageView alloc] initWithFrame:CGRectMake(15, shuiCardView.maxY + 16 * BILI_WIDTH, SCREEN_WIDTH - 30, 100 * BILI_WIDTH)];
    
    [shuiCardView setImage:[UIImage imageNamed:@"icon_shui_card"]];
    [dianCardView setImage:[UIImage imageNamed:@"icon_dian_card"]];
    shuiCardView.userInteractionEnabled = YES;
    dianCardView.userInteractionEnabled = YES;
    
    [theScrollView addSubview:shuiCardView];
    [theScrollView addSubview:dianCardView];
    
    
    UILabel *shuiTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 50 * BILI_WIDTH - 24 * BILI_WIDTH, shuiCardView.w - 40, 24 * BILI_WIDTH)];
    UILabel *dianTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 50 * BILI_WIDTH - 24 * BILI_WIDTH, shuiCardView.w - 40, 24 * BILI_WIDTH)];
    shuiTitle.font = [UIFont systemFontOfSize:14];
    dianTitle.font = [UIFont systemFontOfSize:14];
    shuiTitle.textAlignment = NSTextAlignmentRight;
    dianTitle.textAlignment = NSTextAlignmentRight;
    shuiTitle.textColor = [UIColor whiteColor];
    dianTitle.textColor = [UIColor whiteColor];
    shuiTitle.text = @"上月用水信息";
    dianTitle.text = @"上月用电信息";
    [shuiCardView addSubview:shuiTitle];
    [dianCardView addSubview:dianTitle];
    
    UILabel *shuiDetial = [[UILabel alloc] initWithFrame:CGRectMake(20, 50 * BILI_WIDTH + 15 * BILI_WIDTH, shuiCardView.w - 40, 24 * BILI_WIDTH)];
    UILabel *dianDetial = [[UILabel alloc] initWithFrame:CGRectMake(20, 50 * BILI_WIDTH + 15 * BILI_WIDTH, shuiCardView.w - 40, 24 * BILI_WIDTH)];
    shuiDetial.font = [UIFont systemFontOfSize:15];
    dianDetial.font = [UIFont systemFontOfSize:15];
    shuiDetial.textAlignment = NSTextAlignmentRight;
    dianDetial.textAlignment = NSTextAlignmentRight;
    shuiDetial.textColor = [UIColor whiteColor];
    dianDetial.textColor = [UIColor whiteColor];
    shuiDetial.text = @"用量: --方 费用: --元";
    dianDetial.text = @"用量: --度 费用: --元";
    [shuiCardView addSubview:shuiDetial];
    [dianCardView addSubview:dianDetial];
    
    self.shuiDetialLabel = shuiDetial;
    self.dianDetialLabel = dianDetial;
    
    UIButton *shuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *dianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shuiBtn.backgroundColor = [UIColor clearColor];
    dianBtn.backgroundColor = [UIColor clearColor];
    shuiBtn.frame = CGRectMake(0, 0, shuiCardView.w, shuiCardView.h);
    dianBtn.frame = CGRectMake(0, 0, dianCardView.w, dianCardView.h);
    [shuiBtn addTarget:self action:@selector(payShuiFeeAction) forControlEvents:UIControlEventTouchUpInside];
    [dianBtn addTarget:self action:@selector(payDianFeeAction) forControlEvents:UIControlEventTouchUpInside];
    [shuiCardView addSubview:shuiBtn];
    [dianCardView addSubview:dianBtn];
    
    [self requestShuiDianFee];
}
- (void)payShuiFeeAction{
    SDQFeeDetialViewController *shuiFeeDetialVC = [[SDQFeeDetialViewController alloc] init];
    shuiFeeDetialVC.userType = SDQFeeDetialShui;
    [self.navigationController pushViewController:shuiFeeDetialVC animated:YES];
}
- (void)payDianFeeAction{
    SDQFeeDetialViewController *dianFeeDetialVC = [[SDQFeeDetialViewController alloc] init];
    dianFeeDetialVC.userType = SDQFeeDetialDian;
    [self.navigationController pushViewController:dianFeeDetialVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                                         [SVProgressHUD showErrorWithStatus:@"暂无水电费信息，请稍后继续关注"];
                                                         return;
                                                     }
                                                     NSDictionary *retData = (NSDictionary *)dicData;
                                                     if (retData.count > 0) {
                                                         self.shuiDianFeeInfoDict = [retData copy];
                                                         self.shuiDetialLabel.text = [NSString stringWithFormat:@"用量: %@方 费用: %@元", [retData[@"waterUsed"] description], [retData[@"electricalFee"] description]];
                                                         self.dianDetialLabel.text = [NSString stringWithFormat:@"用量: %@度 费用: %@元", [retData[@"electricalUsed"] description], [retData[@"waterFee"] description]];
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
@end
