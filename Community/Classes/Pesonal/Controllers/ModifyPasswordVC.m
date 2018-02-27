//
//  ModifyPasswordVC.m
//  Community
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "BNBaseTextField.h"
#import "BNSetNewPassWordVC.h"
#import "cc_macro.h"
@interface ModifyPasswordVC ()<UITextFieldDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) BNBaseTextField *phoneTextField;
@property (nonatomic, weak) UIButton *nextStep;

@end

@implementation ModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"修改登录密码";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT- NaviHeight)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NaviHeight);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    theScollView.backgroundColor = UIColorFromRGB(0xececec);
    
    CGFloat originY = 0;
    
    CGRect backgroundViewRect = self.scrollView.frame;
    
    UILabel *tipsPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, backgroundViewRect.size.width - 20, 36*BILI_WIDTH)];
    tipsPhoneLabel.backgroundColor = [UIColor clearColor];
    tipsPhoneLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    tipsPhoneLabel.text = @"修改登录密码前，请验证原密码";
    tipsPhoneLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:tipsPhoneLabel];
    originY += tipsPhoneLabel.frame.size.height;
    
    
    BNBaseTextField *phoneTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, originY, backgroundViewRect.size.width, 45*BILI_WIDTH)];
    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    phoneTF.placeholder = @"请输入原密码";
    phoneTF.secureTextEntry = YES;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:phoneTF];
    _phoneTextField = phoneTF;
    originY += phoneTF.frame.size.height+30*BILI_WIDTH;
    

    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(10, originY, backgroundViewRect.size.width - 10 *2, 40*BILI_WIDTH);
    [nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepButton addTarget:self action:@selector(nextStepTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton setuporangeBtnTitle:@"下一步" enable:NO];
    nextStepButton.layer.masksToBounds = YES;
    [nextStepButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:19]]];
    [nextStepButton setEnabled:NO];
    nextStepButton.layer.cornerRadius = 3;
    [self.scrollView addSubview:nextStepButton];
    _nextStep = nextStepButton;

}

- (void)textFieldEditingChangedValue:(BNBaseTextField *)tf
{
    _nextStep.enabled = tf.text.length > 0;
}

- (void)nextStepTouchUpAction:(UIButton *)nextBtn
{
    //校验原来的密码TODO
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi checkOriginPasswordWithUserId:[UserInfo sharedUserInfo].userId
                                     password:weakSelf.phoneTextField.text
                                      success:^(NSDictionary *successData) {
                                          NSLog(@"校验原密码---->>>> %@",successData);
                                          if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                              [SVProgressHUD dismiss];
                                              BNSetNewPassWordVC *newVC = [[BNSetNewPassWordVC alloc] init];
                                              [weakSelf pushViewController:newVC animated:YES];
                                              
                                          }else{
                                              NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                              [SVProgressHUD showErrorWithStatus:retMsg];
                                          }
                                          
                                      }
                                       failed:^(NSError *error) {
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
