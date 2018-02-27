//
//  VerifyCodeViewController.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "BNBaseTextField.h"
#import "LoginViewController.h"
#import "BNBaseWebViewController.h"
#import "SelectStatusVC.h"

@interface VerifyCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)  UIButton *reSendBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) NSInteger timerSecond;

@property (nonatomic, weak) BNBaseTextField *codeTf;
@property (nonatomic, weak) BNBaseTextField *pswTf;
@property (nonatomic, weak) BNBaseTextField *confirmPswTf;
@property (nonatomic, weak) UIButton *finishBtn;

@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *readButton;

@end

@implementation VerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerSecond = 120;
    
    self.navigationTitle = self.useStyle == VerifyCodeViewControllerUserStyleSettingPsw ? @"设置密码" : @"修改密码";
    [self setupSubViews];
}

- (void)setupSubViews
{
 
    [self setupLoadedView];
    BNBaseTextField *codeTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH ,  30 * BILI_WIDTH, 210 * BILI_WIDTH, 40 * BILI_WIDTH)];
    codeTf.textColor = [UIColor blackColor];
    codeTf.keyboardType = UIKeyboardTypeNumberPad;
    codeTf.placeholder = @"请输入验证码";
    codeTf.delegate = self;
    codeTf.layer.borderWidth = 0.5;
    codeTf.layer.borderColor = UIColor_GrayLine.CGColor;
    [codeTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.baseScrollView addSubview:codeTf];
    _codeTf = codeTf;
    
    BNBaseTextField *pswTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(codeTf.x , codeTf.maxY + 20 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, 40 * BILI_WIDTH)];
    pswTf.placeholder = @"请输入密码";
    pswTf.delegate = self;
    pswTf.layer.borderWidth = 0.5;
    pswTf.secureTextEntry = YES;
    pswTf.layer.borderColor = UIColor_GrayLine.CGColor;
    [pswTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.baseScrollView addSubview:pswTf];
    _pswTf = pswTf;
    
    BNBaseTextField *confirmPswTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(codeTf.x , pswTf.maxY - 0.5, SCREEN_WIDTH - 30 * BILI_WIDTH, 40 * BILI_WIDTH)];
    confirmPswTf.placeholder = @"请确认密码";
    confirmPswTf.delegate = self;
    confirmPswTf.layer.borderWidth = 0.5;
    confirmPswTf.secureTextEntry = YES;
    confirmPswTf.layer.borderColor = UIColor_GrayLine.CGColor;
    [confirmPswTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.baseScrollView addSubview:confirmPswTf];
    _confirmPswTf = confirmPswTf;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(codeTf.x, confirmPswTf.maxY + 16 * BILI_WIDTH, confirmPswTf.w, confirmPswTf.h);
    [finishBtn setuporangeBtnTitle:@"下一步" enable:NO];
    [finishBtn addTarget:self action:@selector(finishBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:finishBtn];
    _finishBtn = finishBtn;
    
    if (self.useStyle == VerifyCodeViewControllerUserStyleSettingPsw) {
        
        CGFloat originY = finishBtn.maxY + 10;
        
        self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.tag = 103;
        _agreeButton.frame = CGRectMake(15 * BILI_WIDTH, originY-4*BILI_WIDTH, 20*BILI_WIDTH, 20*BILI_WIDTH);
        _agreeButton.imageEdgeInsets = UIEdgeInsetsMake(2*BILI_WIDTH, 0, 2*BILI_WIDTH, 4*BILI_WIDTH);
        [_agreeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton setImage:[UIImage imageNamed:@"SignInVC_UnSelectedBtn"] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"SignInVC_SelectedBtn"] forState:UIControlStateSelected];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    [_agreeButton setTitleColor:LoginVC_OrengeBtn_textColor_HighLight forState:UIControlStateHighlighted];
        _agreeButton.layer.cornerRadius = 3;
        _agreeButton.layer.masksToBounds = YES;
        [self.baseScrollView addSubview:_agreeButton];
        _agreeButton.selected = YES;
        
        UILabel *agreeLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_agreeButton.frame), originY, 130*BILI_WIDTH, 13*BILI_WIDTH)];
        agreeLbl.textColor = [UIColor grayColor];
        agreeLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        [self.baseScrollView addSubview:agreeLbl];
        agreeLbl.text = @"已阅读";
        CGFloat textWidth = [Tools getTextWidthWithText:@"已阅读" font:agreeLbl.font height:agreeLbl.frame.size.height];
        agreeLbl.frame = CGRectMake(agreeLbl.frame.origin.x, agreeLbl.frame.origin.y, textWidth, agreeLbl.frame.size.height);
        
        self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _readButton.tag = 104;
        [_readButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_readButton setTitle:@"用户服务协议" forState:UIControlStateNormal];
        [_readButton setTitleColor:UIColor_Button_Normal forState:UIControlStateNormal];
        [_readButton setTitleColor:UIColor_Button_HighLight forState:UIControlStateHighlighted];
        _readButton.titleLabel.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        CGFloat redTextWidth = [Tools getTextWidthWithText:@"用户服务协议" font:agreeLbl.font height:agreeLbl.frame.size.height];
        _readButton.frame = CGRectMake(CGRectGetMaxX(agreeLbl.frame)+5, originY, redTextWidth+10*BILI_WIDTH, 13*BILI_WIDTH);
        
        _readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _readButton.layer.cornerRadius = 3;
        _readButton.layer.masksToBounds = YES;
        [self.baseScrollView addSubview:_readButton];
        
//        originY += _agreeButton.frame.size.height + 30*BILI_WIDTH;
    }
    
    
    UIButton *reSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reSendBtn.frame = CGRectMake(codeTf.maxX, codeTf.y, SCREEN_WIDTH - 15*BILI_WIDTH - codeTf.maxX, codeTf.h);
    [reSendBtn setuporangeBtnTitle:@"120秒后可重发" enable:NO];
    reSendBtn.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [reSendBtn addTarget:self action:@selector(touchDownAcion) forControlEvents:UIControlEventTouchDown];
    [reSendBtn addTarget:self action:@selector(reSendBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:reSendBtn];
    _reSendBtn = reSendBtn;

    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    }
}


- (void)timerMethod
{
    self.timerSecond -= 1;
    NSString *btnTitle = [NSString stringWithFormat:@"%ld秒后可重发",(long)self.timerSecond];
    [_reSendBtn setTitle:btnTitle forState:UIControlStateNormal];
    [_reSendBtn setNeedsDisplay];
    
    if (self.timerSecond <= 0) {
        _reSendBtn.enabled = YES;
        [_reSendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)touchDownAcion
{
    NSLog(@"touchDown");
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        self.timerSecond = 120;
        _reSendBtn.enabled = NO;
    }
}

- (void)reSendBtnAcion
{
    if (self.timer != nil) {
        return;
    }
    
    //重新获取验证码
    if (self.useStyle == VerifyCodeViewControllerUserStyleSettingPsw) {
        //设置密码重新获取验证码
        [RequestApi sendSmsRegWithMobile:self.mobileStr
                                 success:^(NSDictionary *successData) {
                                     NSLog(@"注册发送验证码 ---->>>>> %@",successData);
                                     if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                     }else{
                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                     }
                                 }
                                  failed:^(NSError *error) {
                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  }];

        
        
    }else{
        //忘记密码重新获取验证码
        [RequestApi sendSmsForgetWithMobile:self.mobileStr
                                    success:^(NSDictionary *successData) {
                                        NSLog(@"忘记密码发送验证码 ---->>>>> %@",successData);
                                        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                            
                                        }else{
                                            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                            [SVProgressHUD showErrorWithStatus:retMsg];
                                        }
                                    }
                                     failed:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                     }];

    }
    
}

//完成按钮
- (void)finishBtnAcion
{
    if (![_pswTf.text isEqualToString:_confirmPswTf.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不相等，请重新输入"];
        return;
    }
    
    switch (self.useStyle) {
        case VerifyCodeViewControllerUserStyleSettingPsw: {
            //注册设置密码
            //校验验证码接口
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [RequestApi checkValidCodeWithMobile:self.mobileStr
                                            code:_codeTf.text
                                         success:^(NSDictionary *successData) {
                                             NSLog(@"注册校验验证码--->>>>%@",successData);
                                             if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                 //获取楼宇信息
                                                 [RequestApi getBuildingInfoSuccess:^(NSDictionary *successData) {
                                                     NSLog(@"获取楼宇信息---->>>>%@",successData);
                                                     if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                         [SVProgressHUD dismiss];
                                                         NSMutableArray *buildNames = @[].mutableCopy;
                                                         NSArray *data = [successData valueNotNullForKey:@"data"];
                                                         for (int i = 0; i < data.count; i ++) {
                                                             NSDictionary *dic = data[i];
                                                             NSString *name = [dic valueNotNullForKey:@"buildingName"];
                                                             [buildNames addObject:name];
                                                         }
                                                         SelectStatusVC *selectVC = [[SelectStatusVC alloc] init];
                                                         selectVC.mobile = self.mobileStr;
                                                         selectVC.password = _pswTf.text;
                                                         selectVC.buildings = buildNames;
                                                         [self pushViewController:selectVC animated:YES];
                                                         
                                                     }else{
                                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                     }
                                                     
                                                 } failed:^(NSError *error) {
                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                 }];
                                                 
                                                 
                                             }else{
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                             }
                                             
                                         } failed:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
            
            
            break;
        }
        case VerifyCodeViewControllerUserStyleModifyPsw: {
            //忘记密码 校验验证码
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [RequestApi checkValidCodeWithMobile:self.mobileStr
                                            code:_codeTf.text
                                         success:^(NSDictionary *successData) {
                                             if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                 //修改密码
                                                 [RequestApi modifyUserPasswordWithId:[UserInfo sharedUserInfo].userId newPsw:_pswTf.text success:^(NSDictionary *successData) {
                                                     NSLog(@"修改密码----->>>>>> %@",successData);
                                                     if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                         [SVProgressHUD dismiss];
                                                         
                                                         BOOL isFind = NO;
                                                         for (int i = 0; i < self.navigationController.viewControllers.count; i ++) {
                                                             BNBaseViewController *baseVC = self.navigationController.viewControllers[i];
                                                             if ([baseVC isKindOfClass:NSClassFromString(@"LoginViewController")]) {
                                                                 [self.navigationController popToViewController:baseVC animated:YES];
                                                                 isFind = YES;
                                                                 break;
                                                             }
                                                         }
                                                         if (!isFind) {
                                                             LoginViewController *login = [[LoginViewController alloc] init];
                                                             [self pushViewController:login animated:YES];
                                                         }
                                                         
                                                     }else{
                                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                     }
                                                     
                                                     
                                                 } failed:^(NSError *error) {
                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                 }];

                                                 
                                             }else{
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                             }
                                             
                                         } failed:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
            
            
            break;
        }
    }
    
}

- (void)buttonAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 103: {
            //勾选按钮
            _agreeButton.selected = !_agreeButton.selected;
            [self textFieldEditingChangedValue:nil];
            
            break;
        }
        case 104: {
            //阅读协议
            
            BNBaseWebViewController *protocolVC = [[BNBaseWebViewController alloc] init];
            protocolVC.urlString = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
            protocolVC.navTitle = @"协议";
            [self pushViewController:protocolVC animated:YES];
            
            break;
        }

    }
}

- (void)textFieldEditingChangedValue:(BNBaseTextField *)textField
{
    BOOL agree = NO;
    if (self.useStyle == VerifyCodeViewControllerUserStyleSettingPsw) {
        agree = _agreeButton.selected;
    }else{
        agree = YES;
    }
    if (_codeTf.text.length > 0 && _pswTf.text.length > 0 && _confirmPswTf.text.length > 0 &&  agree) {
        _finishBtn.enabled = YES;
    }else{
        _finishBtn.enabled = NO;
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
