//
//  BNSetNewPassWordVC.m
//  Community
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNSetNewPassWordVC.h"
#import "BNBaseTextField.h"

@interface BNSetNewPassWordVC ()<UITextFieldDelegate>

@property (nonatomic, weak) BNBaseTextField *passwordTf;
@property (nonatomic, weak) BNBaseTextField *confirmPswTf;

@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation BNSetNewPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"设置新密码";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    
    UIView *textBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * BILI_WIDTH, SCREEN_WIDTH, 100 * BILI_WIDTH)];
    textBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:textBGView];
    
   
    
    CGFloat tfHeight = textBGView.h/2.0;
    UIImageView *accountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, (tfHeight - 16) * 0.5, 16, 16)];
    accountIcon.image = [UIImage imageNamed:@"psw_icon"];
    [textBGView addSubview:accountIcon];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(accountIcon.maxX, textBGView.h * 0.5 - 0.5, textBGView.w, 0.5)];
    lineView.backgroundColor = UIColor_GrayLine;
    [textBGView addSubview:lineView];
    
    UIImageView *pswIcon = [[UIImageView alloc] initWithFrame:CGRectMake(accountIcon.x, lineView.maxY +(tfHeight - 16) * 0.5, 16, 16)];
    pswIcon.image = [UIImage imageNamed:@"psw_icon"];
    [textBGView addSubview:pswIcon];
    
    BNBaseTextField *accountTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(accountIcon.maxX , 0, textBGView.w - accountIcon.maxX - 10, tfHeight - 0.5)];
    accountTf.textColor = [UIColor blackColor];
    accountTf.delegate = self;
    accountTf.placeholder = @"请输入新密码";
    accountTf.secureTextEntry = YES;
    [accountTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [textBGView addSubview:accountTf];
    _passwordTf = accountTf;
    
    BNBaseTextField *pswTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(accountTf.x, lineView.maxY, accountTf.w , tfHeight)];
    pswTf.textColor = [UIColor blackColor];
    pswTf.secureTextEntry = YES;
    pswTf.delegate = self;
    pswTf.placeholder = @"请确认密码";
    //   pswTf.text = @"123456";
    [pswTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [textBGView addSubview:pswTf];
    _confirmPswTf = pswTf;
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10, textBGView.maxY + 30, SCREEN_WIDTH - 20, 40*BILI_WIDTH);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(nextStepTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setuporangeBtnTitle:@"确认修改" enable:NO];
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:19]]];
    confirmBtn.layer.cornerRadius = 3;
    [self.baseScrollView addSubview:confirmBtn];
    _confirmBtn = confirmBtn;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if ([string isEqualToString:@" "]) {//不让输入空格
        return NO;
    }
    
    return YES;
}

- (void)textFieldEditingChangedValue:(BNBaseTextField *)tf
{
    if (_confirmPswTf.text.length > 0 && _passwordTf.text > 0) {
        _confirmBtn.enabled = YES;
    }else{
        _confirmBtn.enabled = NO;
    }
}

//确认修改
- (void)nextStepTouchUpAction:(UIButton *)button
{
    if (![_confirmPswTf.text isEqualToString:_passwordTf.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不同，请重新输入"];
        _passwordTf.text = @"";
        _confirmPswTf.text = @"";
        return;
    }
      //修改密码请求.
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi modifyUserPasswordWithId:[UserInfo sharedUserInfo].userId newPsw:_passwordTf.text success:^(NSDictionary *successData) {
        NSLog(@"修改密码----->>>>>> %@",successData);
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            
            BOOL isFind = NO;
            for (UIViewController *subVC in self.navigationController.viewControllers) {
                if ([subVC isKindOfClass:NSClassFromString(@"AccountInfoViewController")]) {
                    [self.navigationController popToViewController:subVC animated:YES];
                    isFind = YES;
                    break;
                }
            }
            
            if (!isFind) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        

    } failed:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];


    

  
}


@end
