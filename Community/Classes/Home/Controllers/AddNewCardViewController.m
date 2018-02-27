//
//  AddNewCardViewController.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AddNewCardViewController.h"
#import "cc_macro.h"
@interface AddNewCardViewController ()

@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
}

- (void)setUseType:(AddNewCardVCUseType)useType
{
    _useType = useType;
    self.navigationTitle = useType == AddNewCardVCUseTypeAddWEG ? @"水电气" : @"绑定新用户";
}

- (void)setupLoadedView
{
    self.telManagerBtn.hidden = NO;
    
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    CGFloat whiteBGViewH = _useType == AddNewCardVCUseTypeAddWEG ?  88*BILI_WIDTH: 44 * BILI_WIDTH;
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, NaviHeight + 13 * BILI_WIDTH, SCREEN_WIDTH - 30 * BILI_WIDTH, whiteBGViewH)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.cornerRadius = 4 * BILI_WIDTH;
    [self.view addSubview:whiteBGView];
    
    UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.frame = CGRectMake(13 * BILI_WIDTH, whiteBGView.maxY + 52 * BILI_WIDTH, SCREEN_WIDTH - 26 * BILI_WIDTH, 34 * BILI_WIDTH);
    [bindBtn setuporangeBtnTitle:@"绑定" enable:YES];
    bindBtn.layer.cornerRadius = 4 * BILI_WIDTH;
    bindBtn.layer.masksToBounds = YES;
    [bindBtn addTarget:self action:@selector(bindAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindBtn];
    
    NSString *typeStr = _useType == AddNewCardVCUseTypeAddWEG ? @"水卡" : @"账户号:";
    UILabel *typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 0, 50 * BILI_WIDTH, 44 * BILI_WIDTH)];
    typeLbl.text = typeStr;
    typeLbl.textColor = [UIColor blackColor];
    typeLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    [whiteBGView addSubview:typeLbl];
    
    if (_useType == AddNewCardVCUseTypeAddWEG) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44*BILI_WIDTH, whiteBGView.w, 1)];
        line.backgroundColor = UIColor_GrayLine;
        [whiteBGView addSubview:line];
        
        UILabel *numLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 44 * BILI_WIDTH + 1, 30 * BILI_WIDTH, 44 * BILI_WIDTH - 1)];
        numLeftLbl.text = @"卡号:";
        numLeftLbl.textColor = [UIColor blackColor];
        numLeftLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
        [whiteBGView addSubview:numLeftLbl];
        
        UITextField *numTf = [[UITextField alloc] initWithFrame:CGRectMake(numLeftLbl.maxX + 5, numLeftLbl.y , whiteBGView.w - numLeftLbl.maxX - 5, 44 * BILI_WIDTH)];
        numTf.placeholder = @"请输入卡号";
        numTf.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:numTf];
    }else if (_useType == AddNewCardVCUseTypeAddNewUser){
        UITextField *numTf = [[UITextField alloc] initWithFrame:CGRectMake(typeLbl.maxX + 5, 0 , whiteBGView.w - typeLbl.maxX - 5, 44 * BILI_WIDTH)];
        numTf.placeholder = @"请输入账号";
        numTf.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:numTf];
        
    }

}


//绑定
- (void)bindAcion
{
    if (_useType == AddNewCardVCUseTypeAddWEG) {
        
    }else if (_useType == AddNewCardVCUseTypeAddNewUser){
        
    }
}


@end
