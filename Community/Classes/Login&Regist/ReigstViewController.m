//
//  ReigstViewController.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ReigstViewController.h"
#import "BNBaseTextField.h"
#import "VerifyCodeViewController.h"

@interface ReigstViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) BNBaseTextField *phoneNumTf;
@property (nonatomic, weak) UIButton *nextButton;

@end

@implementation ReigstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sixtyFourPixelsView.hidden = YES;
    self.customNavigationBar.hidden = YES;
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    UIView *stausBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    stausBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stausBGView];
    
    UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    theScrollView.backgroundColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        theScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    theScrollView.automaticallyAdjustsScrollViewInsets = NO;
#endif
    theScrollView.contentSize = CGSizeMake(theScrollView.w, theScrollView.h + 1);
    theScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:theScrollView];
    
    
    CGFloat imgW = 80 * BILI_WIDTH;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imgW) * 0.5, 56 * BILI_WIDTH, imgW, imgW)];
    iconImageView.layer.cornerRadius = imgW * 0.5;
    iconImageView.image = [UIImage imageNamed:@"logo"];
    [theScrollView addSubview:iconImageView];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.maxY + 8 * BILI_WIDTH, SCREEN_WIDTH, 16*BILI_WIDTH)];
//    nameLabel.textColor = [UIColor blackColor];
//    nameLabel.font = [UIFont systemFontOfSize:16 * BILI_WIDTH];
//    nameLabel.textAlignment = 1;
//    nameLabel.text = app_Name;
//    [theScrollView addSubview:nameLabel];
    
    
    UIView *textBGView = [[UIView alloc] initWithFrame:CGRectMake(22, iconImageView.maxY + 44 * BILI_WIDTH, SCREEN_WIDTH - 44, 50 * BILI_WIDTH)];
    textBGView.layer.borderColor = UIColor_GrayLine.CGColor;
    textBGView.layer.borderWidth = 0.5;
    textBGView.layer.cornerRadius = 24 * BILI_WIDTH;
    textBGView.layer.masksToBounds = YES;
    [theScrollView addSubview:textBGView];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, 18*BILI_WIDTH, 16*BILI_WIDTH, 16*BILI_WIDTH)];
    phoneIcon.image = [UIImage imageNamed:@"regist_phone_icon"];
    [textBGView addSubview:phoneIcon];
    
    BNBaseTextField *accountTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(phoneIcon.maxX , 0, textBGView.w - phoneIcon.maxX - 10, textBGView.h)];
    accountTf.textColor = [UIColor blackColor];
    accountTf.keyboardType = UIKeyboardTypeNumberPad;
    accountTf.placeholder = @"请输入手机号";
    accountTf.delegate = self;
    [accountTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [textBGView addSubview:accountTf];
    _phoneNumTf = accountTf;
    
    
    UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStep.frame = CGRectMake(22 , textBGView.maxY + 20 * BILI_WIDTH, SCREEN_WIDTH - 44 , 39 * BILI_WIDTH);
    [nextStep setuporangeBtnTitle:@"下一步" enable:NO];
    [nextStep addTarget:self action:@selector(nextSetpAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:nextStep];
    _nextButton = nextStep;
    
    NSString *str = @"已有账号，立即登录";
    NSMutableAttributedString *matts = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12*BILI_WIDTH]}];
    [matts setAttributes:@{NSForegroundColorAttributeName: UIColor_Gray_Text} range:NSMakeRange(0, 5)];
    [matts setAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x0080ff)} range:NSMakeRange(5, 4)];
    
    UIButton *goLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    goLogin.frame = CGRectMake((SCREEN_WIDTH - matts.size.width) * 0.5 - 10, CGRectGetHeight(theScrollView.frame) - 40 * BILI_WIDTH,  matts.size.width + 30, 30 * BILI_WIDTH);
    goLogin.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [goLogin setAttributedTitle:matts forState:UIControlStateNormal];
    [goLogin addTarget:self action:@selector(goLoginAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:goLogin];

}

- (void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (tf.text.length == 11) {
        [_nextButton setEnabled:YES];
    }else{
        [_nextButton setEnabled:NO];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if ([string isEqualToString:@" "]) {//不让输入空格
        return NO;
    }
    if (textField.text.length >= 11) {
        return NO;
    }
    
    return YES;
}



- (void)nextSetpAcion:(UIButton *)sender
{
    //注册发送验证码接口
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
        typeof(self) weakSelf = self;
        [RequestApi sendSmsRegWithMobile:_phoneNumTf.text
                                    success:^(NSDictionary *successData) {
                                        NSLog(@"注册发送验证码 ---->>>>> %@",successData);
                                        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                [SVProgressHUD dismiss];
                                                VerifyCodeViewController *verifyCodeVC = [[VerifyCodeViewController alloc] init];
                                                verifyCodeVC.useStyle = VerifyCodeViewControllerUserStyleSettingPsw;
                                                verifyCodeVC.mobileStr = weakSelf.phoneNumTf.text;
                                                [weakSelf pushViewController:verifyCodeVC animated:YES];
    
    
                                        }else{
                                            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                            [SVProgressHUD showErrorWithStatus:retMsg];
                                        }
                                    }
                                     failed:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                     }];

    
    
//    
//    VerifyCodeViewController *codeVC = [[VerifyCodeViewController alloc] init];
//    codeVC.useStyle = VerifyCodeViewControllerUserStyleSettingPsw;
//    codeVC.mobileStr = _phoneNumTf.text;
//    [self pushViewController:codeVC animated:YES];
}

- (void)goLoginAcion:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
