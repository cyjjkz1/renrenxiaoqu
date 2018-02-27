//
//  LoginViewController.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "LoginViewController.h"
#import "BNBaseTextField.h"
#import "ReigstViewController.h"
#import "ModifyPswVC.h"
#import "BNMainViewController.h"
#import "KeychainItemWrapper.h"

#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "cc_macro.h"
#import "LoginTextfield.h"
#import "BNBaseWebViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) LoginTextfield *accountTf;
@property (nonatomic, weak) LoginTextfield *pswTf;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, strong) KeychainItemWrapper *keychain;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sixtyFourPixelsView.hidden = YES;
    self.customNavigationBar.hidden = YES;
    [self setupSubViews];
}

- (void)setupSubViews
{
    UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BottomHeight)];
    theScrollView.contentSize = CGSizeMake(theScrollView.w, SCREEN_HEIGHT - BottomHeight + 1);
    theScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        theScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    theScrollView.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.view addSubview:theScrollView];
    
    CGFloat imgW = 80 * BILI_WIDTH;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imgW) * 0.5, NaviHeight, imgW, imgW)];
    iconImageView.layer.cornerRadius = imgW * 0.5;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"logo"];
    [theScrollView addSubview:iconImageView];
    
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.maxY + 10 * BILI_WIDTH, SCREEN_WIDTH, 20 * BILI_WIDTH)];
    appName.font = [UIFont systemFontOfSize:15*BILI_WIDTH];
    appName.textColor = UIColorFromRGB(0x0080ff);
    appName.textAlignment = NSTextAlignmentCenter;
    appName.text = @"人人小区";
    [theScrollView addSubview:appName];
    
    UIImageView *accountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16*BILI_WIDTH, 16*BILI_WIDTH)];
    accountIcon.image = [UIImage imageNamed:@"account_icon"];
    
    UIImageView *pswIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16*BILI_WIDTH, 16*BILI_WIDTH)];
    pswIcon.image = [UIImage imageNamed:@"psw_icon"];
    
    LoginTextfield *accountTF = [[LoginTextfield alloc] initWithFrame:CGRectMake(40, theScrollView.maxY/2.0 - 88 * BILI_WIDTH, kCCScreenWidth - 80, 44 * BILI_WIDTH)];
    accountTF.placeholder = @"请输入账号";
    accountTF.leftView = accountIcon;
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    accountTF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40 * BILI_WIDTH, 40 * BILI_WIDTH)];
    accountTF.rightViewMode = UITextFieldViewModeAlways;
    _accountTf = accountTF;
    [accountTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [theScrollView addSubview:accountTF];
    
    UIButton *pwdVisibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pwdVisibleBtn.frame = CGRectMake(0, 0, 40 * BILI_WIDTH, 40 * BILI_WIDTH);
    pwdVisibleBtn.backgroundColor = [UIColor clearColor];
    [pwdVisibleBtn setImage:[UIImage imageNamed:@"show_psw"] forState:UIControlStateNormal];
    [pwdVisibleBtn addTarget:self action:@selector(showOrHiddenPasswordAcction:) forControlEvents:UIControlEventTouchUpInside];
    
    LoginTextfield *passwordTF = [[LoginTextfield alloc] initWithFrame:CGRectMake(40, accountTF.maxY + 10 * BILI_WIDTH, kCCScreenWidth - 80, 44 * BILI_WIDTH)];
    passwordTF.placeholder = @"请输入密码";
    passwordTF.leftView = pswIcon;
    passwordTF.leftViewMode = UITextFieldViewModeAlways;
    passwordTF.rightView = pwdVisibleBtn;
    passwordTF.rightViewMode = UITextFieldViewModeAlways;
    passwordTF.secureTextEntry = YES;
    _pswTf = passwordTF;
    [passwordTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [theScrollView addSubview:passwordTF];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(60 , passwordTF.maxY + 30 * BILI_WIDTH, SCREEN_WIDTH - 120 , 40 * BILI_WIDTH);
    loginBtn.layer.cornerRadius = 20 * BILI_WIDTH;
    [loginBtn setuporangeBtnTitle:@"登录" enable:NO];
    [loginBtn addTarget:self action:@selector(loginAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake((kCCScreenWidth - 80)/2.0 , loginBtn.maxY + 20 * BILI_WIDTH, 80 * BILI_WIDTH , 13 * BILI_WIDTH);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetBtn setTitleColor:UIColorFromRGB(0x0080ff) forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(loginAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:forgetBtn];
    
    NSString *str = @"没有账号？立即注册";
    NSMutableAttributedString *matts = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12*BILI_WIDTH]}];
    [matts setAttributes:@{NSForegroundColorAttributeName: UIColor_Gray_Text} range:NSMakeRange(0, 5)];
    [matts setAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x0080ff)} range:NSMakeRange(5, 4)];
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake((SCREEN_WIDTH - matts.size.width - 30) * 0.5, theScrollView.h - 70 * BILI_WIDTH,  matts.size.width + 50, 30 * BILI_WIDTH);
    registBtn.titleLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    registBtn.backgroundColor = [UIColor whiteColor];
    [registBtn setAttributedTitle:matts forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registAcion:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"window %@", NSStringFromCGRect(registBtn.frame));

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, registBtn.y + registBtn.h/2, SCREEN_WIDTH - 160, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [theScrollView addSubview:line];
    [theScrollView addSubview:registBtn];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.frame = CGRectMake((SCREEN_WIDTH - matts.size.width) * 0.5 - 10, theScrollView.h - 40 * BILI_WIDTH,  matts.size.width + 30, 30 * BILI_WIDTH);
    [protocolBtn setTitle:@"软件协议及服务许可" forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [protocolBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(goProtocolPage) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:protocolBtn];
    
    self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
    NSString *phoneNum = [self.keychain objectForKey:(id)kSecAttrAccount];
    if (phoneNum && phoneNum.length > 0) {
        accountTF.text = phoneNum;
    }
}
- (void)goProtocolPage
{
    BNBaseWebViewController *protocolVC = [[BNBaseWebViewController alloc] init];
    protocolVC.urlString = @"https://www.sqguanjia.com/protocol.html";
    protocolVC.navTitle = @"软件许可及服务协议";
    [self pushViewController:protocolVC animated:YES];
}
- (void)showOrHiddenPasswordAcction:(UIButton *)btn
{
    _pswTf.secureTextEntry = !_pswTf.secureTextEntry;
}

- (void)loginAcion:(UIButton *)button
{
//    NSString *userId = @"14";
//    UserInfo *user = [UserInfo sharedUserInfo];
//    user.login = YES;
//    [self.keychain setObject:userId forKey:(id)kSecValueData];
    
    if (button == _loginBtn) {
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [RequestApi loginWithMobile:_accountTf.text
                           password:_pswTf.text
                            success:^(NSDictionary *successData) {
                               NSLog(@"登录接口--->>>>%@",successData);
                               if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                   [SVProgressHUD dismiss];
                                   UserInfo *user = [UserInfo sharedUserInfo];
                                   user.login = YES;
                                   
                                   //保存上次登录的用户名
                                   [weakSelf.keychain setObject:_accountTf.text forKey:(id)kSecAttrAccount];
                                   
                                   //保存上次登录的userId
                                   NSDictionary *data = successData[kRequestReturnData];
                                   NSString *userId = [NSString stringWithFormat:@"%@",data[@"id"]];
                                   
                                   [weakSelf.keychain setObject:userId forKey:(id)kSecValueData];
                                   
                                   //切换window 的根试图控制器
                                   UIWindow *window = [UIApplication sharedApplication].delegate.window;
                                   window.rootViewController = [[BNMainViewController alloc] init];
                                   
                                   [UIView beginAnimations:nil context:nil];
                                   [UIView setAnimationDuration:1];
                                   // forView: 动画在哪一个view上执行
                                   [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:window cache:YES];
                                   [UIView commitAnimations];
                               }else{
                                   NSString *retMsg = successData[kRequestRetMessage];
                                   [SVProgressHUD showErrorWithStatus:retMsg];
                               }
                               
                           } failed:^(NSError *error) {
                               [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                               NSLog(@"%@",error);
                           }];
    }else{
        //忘记密码
        ModifyPswVC *modifyVC = [[ModifyPswVC alloc] init];
        [self pushViewController:modifyVC animated:YES];
    }
}

- (void)registAcion:(UIButton *)button
{
    //注册
    ReigstViewController *registVC = [[ReigstViewController alloc] init];
    [self pushViewController:registVC animated:YES];
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

- (void)textFieldEditingChangedValue:(LoginTextfield *)tf
{
    if (_accountTf.text.length > 11) {
        _accountTf.text = [_accountTf.text substringWithRange:NSMakeRange(0, 11)];
    }
    if (_pswTf.text.length > 18) {
        _pswTf.text = [_pswTf.text substringWithRange:NSMakeRange(0, 18)];
    }
    if (_accountTf.text.length == 11 && _pswTf.text.length >= 6) {
        _loginBtn.enabled = YES;
    }else{
        _loginBtn.enabled = NO;
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
