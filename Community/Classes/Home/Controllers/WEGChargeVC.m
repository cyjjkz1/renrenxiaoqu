//
//  WEGChargeVC.m
//  Community
//
//  Created by mac1 on 2016/10/13.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "WEGChargeVC.h"
#import "BNBaseTextField.h"
#import "BNPayCenterHomeVC.h"
#import "cc_macro.h"
@interface WEGChargeVC ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *chargeBtn;

@property (nonatomic, weak) UITextField *textfield;

@end

@implementation WEGChargeVC

- (void)setChargeType:(WEGChargeVCUseType)chargeType
{
    _chargeType = chargeType;
    if (chargeType == WEGChargeVCUseTypeWaterEle) {
         self.navigationTitle = @"水电费缴纳";
    }else{
        self.navigationTitle = @"物业费缴纳";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
    [kNotificationCenter addObserver:self selector:@selector(chargeFinish) name:kNotification_chargeFinish object:nil];
}

- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    BNBaseTextField *textField = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, NaviHeight + 20*BILI_WIDTH, SCREEN_WIDTH, 45*BILI_WIDTH)];
//    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
//    [textField addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
    textField.enabled = NO;
    textField.clearButtonMode = UITextFieldViewModeNever;
    [self.view addSubview:textField];
    _textfield = textField;
    
    UIButton *chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chargeBtn.frame = CGRectMake(10 * BILI_WIDTH, textField.maxY + 20 * BILI_WIDTH, SCREEN_WIDTH - 20*BILI_WIDTH, 40);
    [chargeBtn setuporangeBtnTitle:@"确认缴费" enable:[self chargeBtnCanUse]];
    [chargeBtn addTarget:self action:@selector(chargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargeBtn];
    _chargeBtn = chargeBtn;
    
    if (self.amount && self.amount.length > 0) {
        NSString *type;
        if (_chargeType == WEGChargeVCUseTypeWaterEle) {
            type = @"水电费";
        }else{
            type = @"物业费";
        }
         textField.text =  [NSString stringWithFormat:@"您应缴纳的%@为：%@元",type,self.amount];
    }else{
       textField.text = @"您暂无缴费项目";
    }
    
    
}

- (BOOL)chargeBtnCanUse
{
    if (self.amount && self.amount.length > 0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)chargeBtnAction
{
    //弹出半透明模态UINavigationController
    BNPayCenterHomeVC *payVC = [[BNPayCenterHomeVC alloc] init];
    if (_chargeType == WEGChargeVCUseTypeWaterEle) {
        payVC.payProjectType = PayProjectTypeWater;
    }else{
        payVC.payProjectType = PayProjectTypeWuYe;
    }
    payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
        //        returnBlock(jumpType, params);
    };
    payVC.amount = self.amount;
    payVC.orderId = self.orderId;
    self.definesPresentationContext = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    nav.navigationBarHidden = YES;
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:nav animated:NO completion:nil];
    
}
/*
- (void)textAction:(UITextField *)textField
{
    _chargeBtn.enabled = textField.text.length > 0;
    
    // 第一个数是小数点搞成空
    NSString *str = textField.text;
    if ([str isEqualToString:@"."])
    {
        str = @"";
    }
    
    // 如果输入框以0开头 第二个数字不为0，则转化为intvalue，编程一个数字，第二个为小数点跳出方法。
    else if([str hasPrefix:@"0"] && str.length ==2 )
    {
        if ([str isEqualToString:@"0."])
        {
            return;
        }
        str = [NSString stringWithFormat:@"%ld",(long)[str integerValue]];
    }
    
    else {
        //限制小数点后两位
        NSString *findStr = @".";
        NSRange foundObj=[str rangeOfString:findStr options:NSCaseInsensitiveSearch];
        if(foundObj.length>0)
        {
            if (str.length > foundObj.location + 3)
            {
                str = [str substringWithRange:NSMakeRange(0, foundObj.location + 3)];
                [textField resignFirstResponder];
            }
        }
        
        //pointCount为str中“.“的个数，限制一个小数点
        NSInteger pointCount = [[str componentsSeparatedByString:@"."] count]-1;
        if(pointCount > 1)
        {
            str = [str substringWithRange:NSMakeRange(0, str.length-1)];
            
        }
    }
    textField.text = str;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    if([string isEqualToString:@" "]){
        return NO;
    }
    if (textField.tag == 100) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger flag=0;
        
        const NSInteger limited = 2;//小数点后需要限制的个数
        
        
        for (int i = futureString.length - 1; i >= 0; i --)
        {
            if ([futureString characterAtIndex:i] == '.')
            {
                if (flag > limited)
                {
                    [textField resignFirstResponder];
                    return NO;
                }
                break;
            }
            flag ++;
        }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

*/

- (void)chargeFinish
{
    NSLog(@"收到通知");
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
