//
//  WEGDetailViewController.m
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "WEGDetailViewController.h"
#import "MoreFunctionDropView.h"
#import "ShowDetailViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface WEGDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) MoreFunctionDropView *dropView;

@end

@implementation WEGDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"账号详情";
    [self setupLoadedView];
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.view.backgroundColor = UIColor_Gray_BG;
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(SCREEN_WIDTH - 33, 2, 20, 40);
    [rightBar setImage:[UIImage imageNamed:@"more_btn"] forState:UIControlStateNormal];
    [rightBar addTarget:self action:@selector(moreAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightBar];
    
    
    self.baseScrollView.delegate = self;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(14, 12 * BILI_WIDTH, SCREEN_WIDTH - 28, 168 * BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4*BILI_WIDTH;
    whiteView.layer.masksToBounds = YES;
    [self.baseScrollView addSubview:whiteView];
    
    
    UIView *imageContainerView = [[UIView alloc] initWithFrame:CGRectMake((whiteView.w - 65 * BILI_WIDTH) * 0.5, 17 * BILI_WIDTH, 65 * BILI_WIDTH, 65 * BILI_WIDTH)];
    imageContainerView.backgroundColor = [UIColor whiteColor];
    imageContainerView.layer.cornerRadius = imageContainerView.w * 0.5;
    imageContainerView.layer.masksToBounds = YES;
    imageContainerView.layer.borderColor = UIColor_GrayLine.CGColor;
    imageContainerView.layer.borderWidth = 1;
    [whiteView addSubview:imageContainerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37 * BILI_WIDTH, 30 * BILI_WIDTH)];
    imageView.center = imageContainerView.center;
    imageView.image = [UIImage imageNamed:@"sk"];
    [whiteView addSubview:imageView];
    
    UILabel *balanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, imageContainerView.maxY + 14 * BILI_WIDTH, whiteView.w, 14 * BILI_WIDTH)];
    balanceLbl.textAlignment = 1;
    balanceLbl.textColor = UIColor_Gray_Text;
    balanceLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    balanceLbl.text = @"余额：36.03元";
    [whiteView addSubview:balanceLbl];
    
    UILabel *deadline = [[UILabel alloc] initWithFrame:CGRectMake(0, balanceLbl.maxY + 14 * BILI_WIDTH, whiteView.w, 14 * BILI_WIDTH)];
    deadline.textAlignment = 1;
    deadline.textColor = UIColor_Gray_Text;
    deadline.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    deadline.text = @"截止时间：2016-06-21";
    [whiteView addSubview:deadline];
    
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(whiteView.x, whiteView.maxY + 19 * BILI_WIDTH, whiteView.w, 34 * BILI_WIDTH);
    checkBtn.tag = 666;
    [checkBtn setupWhiteBtnTitle:@"查 看 明 细" enable:YES];
    [checkBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:checkBtn];
    
    UIButton *chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chargeBtn.frame = CGRectMake(whiteView.x, checkBtn.maxY + 17 * BILI_WIDTH, whiteView.w, 34 * BILI_WIDTH);
    chargeBtn.tag = 999;
    chargeBtn.layer.cornerRadius = 4;
    chargeBtn.layer.masksToBounds = YES;
    [chargeBtn setuporangeBtnTitle:@"充 值" enable:YES];
    [checkBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:chargeBtn];
    
}


- (void)buttonAcion:(UIButton *)sender
{
    if (sender.tag == 666) {
        //查看明细
        ShowDetailViewController *detailVC = [[ShowDetailViewController alloc] init];
        [self pushViewController:detailVC animated:YES];
        
    }else{
        // 充值
        
        /*
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = appID;
        
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
        order.biz_content.body = @"我是测试数据";
        order.biz_content.subject = @"1";
        order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
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
            NSString *appScheme = @"alisdkdemo";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
        */
    }
}


- (void)moreAcion:(UIButton *)button
{
    if (_dropView) {
        [_dropView removeFromSuperview];
        _dropView = nil;
        return;
    }
    CGRect dropRect = CGRectMake(SCREEN_WIDTH - 87 * BILI_WIDTH - 14, button.maxY + 20, 87 * BILI_WIDTH, 54 * BILI_WIDTH);
    NSArray *titles = @[@"解除绑定", @"联系物管"];
    MoreFunctionDropView *dropView = [[MoreFunctionDropView alloc] initWithFrame:dropRect itemTitles:titles];
    typeof(dropView) weakDropView = dropView;
    dropView.clickedBlock = ^(NSInteger index)
    {
        [weakDropView removeFromSuperview];
        _dropView = nil;
        switch (index) {
            case 0:
            {
                //解除绑定
                
            }
                break;
            case 1:
            {
                //联系物管
                UIWebView *webView = [[UIWebView alloc]init];
                NSURL *url = [NSURL URLWithString:@"tel://13688426514"];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];
            }
                break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:dropView];
    _dropView = dropView;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_dropView) {
        [_dropView removeFromSuperview];
        _dropView = nil;
    }
}

@end
