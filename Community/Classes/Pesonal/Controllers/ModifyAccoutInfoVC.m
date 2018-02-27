//
//  ModifyAccoutInfoVC.m
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ModifyAccoutInfoVC.h"
#import "BNBaseTextField.h"
#import "cc_macro.h"
@interface ModifyAccoutInfoVC ()

@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation ModifyAccoutInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = self.useStyle == ModifyAccoutInfoVCUseStyleChangeName ? @"修改姓名" : @"修改小区名";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    BNBaseTextField *textField = [[BNBaseTextField alloc] initWithFrame:CGRectMake(-1, NaviHeight + 20, SCREEN_WIDTH + 2, 40*BILI_WIDTH)];
    textField.placeholder = self.useStyle == ModifyAccoutInfoVCUseStyleChangeName ? @"请输入您的姓名" : @"请输入小区名";
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.layer.borderWidth = 0.5;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    _textField = textField;
    
    UIButton *confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbtn.frame = CGRectMake(20*BILI_WIDTH, textField.maxY + 30*BILI_WIDTH, SCREEN_WIDTH - 40*BILI_WIDTH, 35*BILI_WIDTH);
    [confirmbtn setuporangeBtnTitle:@"确 认" enable:NO];
    [confirmbtn addTarget:self action:@selector(confirmBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmbtn];
    _confirmBtn = confirmbtn;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)textChanged:(BNBaseTextField *)textField
{
    _confirmBtn.enabled = textField.text.length > 0;
}

- (void)confirmBtnAcion
{
    switch (self.useStyle) {
        case ModifyAccoutInfoVCUseStyleChangeName:
        {
            self.editFinishBlock(_textField.text);
        }
            break;
        case ModifyAccoutInfoVCUseStyleChangeVillige:
        {
            self.editFinishBlock(_textField.text);
        }
            break;

            
        default:
            break;
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
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
