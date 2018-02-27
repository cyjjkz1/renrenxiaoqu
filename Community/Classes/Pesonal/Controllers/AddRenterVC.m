//
//  AddRenterVC.m
//  Community
//
//  Created by mac1 on 2016/10/18.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AddRenterVC.h"
#import "BNBaseTextField.h"
#import "RenterMangeVC.h"
#import "cc_macro.h"
@interface AddRenterVC ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) BNBaseTextField *textField;

@end

@implementation AddRenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    self.navigationTitle = @"添加住户";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    BNBaseTextField *textField = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, NaviHeight + 30, SCREEN_WIDTH, 50)];
    textField.placeholder = @"请输入住户手机号";
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    _textField = textField;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10, textField.maxY + 30, SCREEN_WIDTH - 20, 40);
    [confirmBtn setuporangeBtnTitle:@"提 交" enable:NO];
    [confirmBtn addTarget:self action:@selector(confirmBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    _confirmBtn = confirmBtn;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    if([string isEqualToString:@" "]){
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 11) {
        return NO;
    }
    return YES;
}

- (void)textChange:(BNBaseTextField *)tf
{

    if(tf.text.length == 11){
        _confirmBtn.enabled = YES;
    }
}

- (void)confirmBtnAcion
{
    if (![_textField.text hasPrefix:@"1"]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        _textField.text = @"";
        _confirmBtn.enabled = NO;
        return;
    }else{
        //添加租户接口
        [RequestApi createLesseesWithUserId:[UserInfo sharedUserInfo].userId renterMobile:_textField.text success:^(NSDictionary *successData) {
            NSLog(@"添加住户--->>>>%@",successData);
            if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [SVProgressHUD showSuccessWithStatus:@"添加住户成功"];
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.4*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self goBack];
                });

            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
            
        } failed:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
}

- (void)goBack
{
    for (int i = 0; i < self.navigationController.viewControllers.count; i ++) {
        BNBaseViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"RenterMangeVC")]) {
            RenterMangeVC *renterVC = (RenterMangeVC *)vc;
            [renterVC addRenterSuccessAndRefreshInfo];
            [self.navigationController popToViewController:renterVC animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
