//
//  ModifyPswVC.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ModifyPswVC.h"
#import "BNBaseTextField.h"
#import "VerifyCodeViewController.h"

@interface ModifyPswVC ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *nextStep;
@property (weak, nonatomic) UITextField *textField;

@end

@implementation ModifyPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"修改密码";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self setupLoadedView];
    BNBaseTextField *textField = [[BNBaseTextField alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH , 30 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, 40 * BILI_WIDTH)];
    textField.textColor = [UIColor blackColor];
    textField.placeholder = @"请输入手机号码";
    textField.delegate = self;
    textField.layer.cornerRadius = 20 * BILI_WIDTH;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = UIColor_GrayLine.CGColor;
    [textField addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.baseScrollView addSubview:textField];
    _textField = textField;
    
    UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStep.frame = CGRectMake(textField.x, textField.maxY + 20 * BILI_WIDTH, textField.w, 35 * BILI_WIDTH);
    [nextStep setuporangeBtnTitle:@"下一步" enable:NO];
    [nextStep addTarget:self action:@selector(nextBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextStep];
    _nextStep = nextStep;

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

- (void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (tf.text.length == 11) {
        _nextStep.enabled = YES;
    }else{
        _nextStep.enabled = NO;
    }
}
- (void)nextBtnAcion
{
    //忘记密码发送验证码
    [SVProgressHUD showWithStatus:@"请稍后..."];
    typeof(self) weakSelf = self;
    [RequestApi sendSmsForgetWithMobile:_textField.text
                                success:^(NSDictionary *successData) {
                                    NSLog(@"忘记密码发送验证码 ---->>>>> %@",successData);
                                    if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                        [SVProgressHUD dismiss];
                                        VerifyCodeViewController *verifyCodeVC = [[VerifyCodeViewController alloc] init];
                                        verifyCodeVC.useStyle = VerifyCodeViewControllerUserStyleModifyPsw;
                                        verifyCodeVC.mobileStr = weakSelf.textField.text;
                                        [weakSelf pushViewController:verifyCodeVC animated:YES];
                                    }else{
                                        NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                    }
                                }
                                 failed:^(NSError *error) {
                                     NSLog(@"%@",error);
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];
  
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
