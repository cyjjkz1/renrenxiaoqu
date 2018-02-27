//
//  SelectStatusVC.m
//  Community
//
//  Created by mac1 on 2016/10/18.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "SelectStatusVC.h"
#import "LoginViewController.h"
#import "LCPickerView.h"

@interface SelectStatusVC ()<UIAlertViewDelegate, LCPickerViewDelegate, LCPickerViewDataSouce>

@property (nonatomic, weak) UIButton *finishBtn;
@property (nonatomic, weak) UIImageView *selectedImageView1;
@property (nonatomic, weak) UIImageView *selectedImageView2;
@property (nonatomic, weak) UIImageView *selectedImageView3;
@property (nonatomic, weak) LCPickerView *showingPickerView;

@property (nonatomic, weak) UIView *whiteBGView1;
@property (nonatomic, weak) UIView *whiteBGView2;

@property (nonatomic, strong) NSArray *placeholds;
@property (nonatomic, assign) NSInteger selectedIndex;

//门牌号
@property (nonatomic, strong) NSMutableArray *houseNumber;

@end

@implementation SelectStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"选择身份";
    
    [self setupLoadedView];
}

- (NSMutableArray *)houseNumber{
    if (!_houseNumber) {
        _houseNumber = [[NSMutableArray alloc] init];
    }
    return _houseNumber;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    NSString *status;
    if (selectedIndex == 666) {
        status = @"业主";
    }else if (selectedIndex == 999){
        status = @"住户";
    }else if(selectedIndex == 888){
        status = @"非小区人士";
    }
    NSString *msg = [NSString stringWithFormat:@"您将选择%@，选择后将不能更改，请确认！",status];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"重新选择",nil];
    [alertView show];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    
    _selectedIndex = 0;
    
    UILabel *tipsPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 36*BILI_WIDTH)];
    tipsPhoneLabel.backgroundColor = [UIColor clearColor];
    tipsPhoneLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    tipsPhoneLabel.text = @"请选择您的身份";
    tipsPhoneLabel.textColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:tipsPhoneLabel];
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, tipsPhoneLabel.maxY, SCREEN_WIDTH, 135)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBGView];
    _whiteBGView1 = whiteBGView;
    
    UILabel *ownerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 45)];
    ownerLbl.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    ownerLbl.textColor = [UIColor blackColor];
    ownerLbl.text = @"我是业主";
    [whiteBGView addSubview:ownerLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBGView addSubview:line];
    
    UILabel *renterLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 200, 44.5)];
    renterLbl.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    renterLbl.textColor = [UIColor blackColor];
    renterLbl.text = @"我是住户";
    [whiteBGView addSubview:renterLbl];
    
    UIView *line1 =  [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = UIColor_GrayLine;
    [whiteBGView addSubview:line1];
    
    UILabel *otherLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 90.5, 200, 44.5)];
    otherLbl.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    otherLbl.textColor = [UIColor blackColor];
    otherLbl.text = @"非小区人士";
    [whiteBGView addSubview:otherLbl];
    
    UIButton *ownerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ownerBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    ownerBtn.tag = 666;
    ownerBtn.backgroundColor = [UIColor clearColor];
    [ownerBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView addSubview:ownerBtn];
    
    UIButton *renterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    renterBtn.frame = CGRectMake(0, 45, SCREEN_WIDTH, 45);
    renterBtn.tag = 999;
    renterBtn.backgroundColor = [UIColor clearColor];
    [renterBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView addSubview:renterBtn];
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.frame = CGRectMake(0, 90, SCREEN_WIDTH, 45);
    otherBtn.tag = 888;
    otherBtn.backgroundColor = [UIColor clearColor];
    [otherBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView addSubview:otherBtn];
    
    UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 15, 15, 15)];
    selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
    selectImgV.hidden = YES;
    [whiteBGView addSubview:selectImgV];
    _selectedImageView1 = selectImgV;
    
    UIImageView *selectImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 45+15, 15, 15)];
    selectImgV1.image = [UIImage imageNamed:@"Select_Bank_card"];
    selectImgV1.hidden = YES;
    [whiteBGView addSubview:selectImgV1];
    _selectedImageView2 = selectImgV1;
    
    UIImageView *selectImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 90+15, 15, 15)];
    selectImgV2.image = [UIImage imageNamed:@"Select_Bank_card"];
    selectImgV2.hidden = YES;
    [whiteBGView addSubview:selectImgV2];
    _selectedImageView3 = selectImgV2;
    
    UIView *whiteV2 = [[UIView alloc] initWithFrame:CGRectMake(0, whiteBGView.maxY + 10, SCREEN_WIDTH, 90)];
    whiteV2.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteV2];
    _whiteBGView2 = whiteV2;
    
    NSArray *titles = @[@"楼宇", @"门牌号"];
    self.placeholds = @[@"请选择楼宇", @"请选择门牌号"];
    for (int i = 0; i < 2; i ++) {
        UILabel *leftTit = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 * i, 64, 45)];
        leftTit.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        leftTit.text = titles[i];
//        leftTit.backgroundColor = [UIColor redColor];
        leftTit.textColor = [UIColor blackColor];
        [whiteV2 addSubview:leftTit];
        
        UIButton *placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        placeBtn.frame = CGRectMake(leftTit.maxX + 10, leftTit.y, SCREEN_WIDTH - leftTit.maxX - 10, leftTit.h);
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        placeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        placeBtn.tag = i + 1;
        [placeBtn setTitle:self.placeholds[i] forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [whiteV2 addSubview:placeBtn];
        [placeBtn addTarget:self action:@selector(prePickerView:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = UIColor_GrayLine;
            [whiteV2 addSubview:line];
        }
    }
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(10, whiteV2.maxY + 20, SCREEN_WIDTH - 20, 40);
    [finishBtn setuporangeBtnTitle:@"完 成" enable:NO];
    finishBtn.tag = 111;
    [finishBtn addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:finishBtn];
    _finishBtn = finishBtn;
    
    
    
}


//准备弹出pickerView；
- (void)prePickerView:(UIButton *)btn
{
    if (btn.tag == 2) {
        UIButton *buildingBtn = (UIButton *)[_whiteBGView2 viewWithTag:1];
        NSString *building = buildingBtn.titleLabel.text;
        if ([building isEqualToString:self.placeholds[0]]) {
            [SVProgressHUD showErrorWithStatus:@"请先选择楼宇"];
            return;
        }else{
            //获取房间号
            [SVProgressHUD showWithStatus:@"请稍后..."];
            __weak typeof(self) weakSelf = self;
            [RequestApi getRoomsWithbuildingName:building
                                         Success:^(NSDictionary *successData) {
                                             NSLog(@"获取房间号-------%@",successData);
                                             if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray *data = [successData valueNotNullForKey:@"data"];
                                                 [weakSelf.houseNumber removeAllObjects];
                                                 
                                                 for (int i = 0; i < data.count; i ++) {    
                                                     NSDictionary *dic = data[i];
                                                     NSString *roomName = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"roomName"]];
                                                     [weakSelf.houseNumber addObject:roomName];
                                                     
                                                 }
                                                 
                                                 [weakSelf showPickerView:2];
                                             }else{
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                             }
                                             
                                         }
                                          failed:^(NSError *error) {
                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                          }];
        }
        
    }else{
        [self showPickerView:1];
    }
   
   
}

// 弹出pickerView
- (void)showPickerView:(NSInteger)btnTag
{
    CGFloat pickerItmH = 50;
    NSArray *arr =  btnTag == 1 ? self.buildings : self.houseNumber;
    CGFloat pickerH = pickerItmH * (arr.count >= 5 ? 5 : arr.count);
    
    if (_showingPickerView) {
        [_showingPickerView dismissPickerView];
    }
    LCPickerView *pickerView = [[LCPickerView alloc] initWithFrame:CGRectMake(0,  SCREEN_HEIGHT - pickerH - 40, SCREEN_WIDTH, pickerH + 40)];
    pickerView.tag = 10 * btnTag;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSouce = self;
    [pickerView setSelectedRow:0 inComponent:1];
    [pickerView showInView:self.view];
    _showingPickerView = pickerView;
}

#pragma mark LCPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(LCPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(LCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     NSArray *arr = pickerView.tag == 10 ? self.buildings : self.houseNumber;
    return arr.count;
}

- (NSString *)lc_pickerView:(LCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSArray *arr = pickerView.tag == 10 ? self.buildings : self.houseNumber;
    
    return arr[row];
}


#pragma mark LCPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger btnTag = pickerView.tag / 10;
    
    UIButton *button = (UIButton *)[_whiteBGView2 viewWithTag:btnTag];
    button.selected = YES;
//    NSArray *models = self.saleDatas[[NSString stringWithFormat:@"%ld",(long)btnTag]];
//    HouseTypeModel *model = models[row];
    NSArray *arr = pickerView.tag == 10 ? self.buildings : self.houseNumber;
    [button setTitle:[arr objectAtIndex:row] forState:UIControlStateNormal];
    [self checkFinishButonCanUse];
}

//取消
- (void)pickerViewDidCancel:(LCPickerView *)pickerView
{
    NSInteger btnTag = pickerView.tag / 10;
    UIButton *button = [_whiteBGView2 viewWithTag:btnTag];
    button.selected = NO;
    [button setTitle:self.placeholds[btnTag-1] forState:UIControlStateNormal];
    
    _showingPickerView = nil;
    [self checkFinishButonCanUse];
}


- (void)buttonAcion:(UIButton *)button
{
    if (button.tag == 666) {
        self.selectedIndex = 666;
    }else if (button.tag == 999){
        self.selectedIndex = 999;
    }else if (button.tag == 888){
        self.selectedIndex = 888;
    }else{
        //注册
            NSString *status;
            if (self.selectedIndex == 666) {
                status = @"1";
            }else if (self.selectedIndex == 999){
                status = @"2";
            }else{
                status = @"3";
            }
        UIButton *budingBtn = [_whiteBGView2 viewWithTag:1];
        UIButton *houseNumberBtn = [_whiteBGView2 viewWithTag:2];
        NSString *buding = budingBtn.titleLabel.text;
        NSString *houseNum = houseNumberBtn.titleLabel.text;
        if (_selectedIndex == 888) {
            buding = nil;
            houseNum = nil;
        }
        
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [RequestApi registWithMobile:self.mobile
                                password:self.password
                                    type:status
                            buildingName:buding
                                roomName:houseNum
                                 success:^(NSDictionary *successData) {
                                     NSLog(@"注册接口----->>>>>> %@",successData);
                                     if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                         [SVProgressHUD dismiss];
        
                                         //注册成功，跳转登录界面
                                         LoginViewController *loginVC = [[LoginViewController alloc] init];
                                         [self pushViewController:loginVC animated:YES];
        
                                     }else{
                                         [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                     }
                                 } failed:^(NSError *error) {
                                     NSLog(@"%@",error);
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];
     
    }
}

//完成按钮是否可点击
- (void)checkFinishButonCanUse
{
    if (_selectedIndex == 888) {
        _finishBtn.enabled = YES;
        return;
    }
    UIButton *budingBtn = [_whiteBGView2 viewWithTag:1];
    UIButton *houseNumberBtn = [_whiteBGView2 viewWithTag:2];
    NSString *buding = budingBtn.titleLabel.text;
    NSString *houseNum = houseNumberBtn.titleLabel.text;
    NSString *placeholders1 = [self.placeholds objectAtIndex:0];
    NSString *palceholders2 = [self.placeholds objectAtIndex:1];

    if (_selectedIndex != 0 && ![buding isEqualToString:placeholders1] && ![houseNum isEqualToString:palceholders2]) {
        _finishBtn.enabled = YES;
    }else{
        _finishBtn.enabled = NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }
 
    if (_selectedIndex == 666) {
        _selectedImageView1.hidden = NO;
        _selectedImageView2.hidden = YES;
        _selectedImageView3.hidden = YES;
        _whiteBGView2.hidden = NO;
        _finishBtn.y = _whiteBGView2.maxY + 20;
    }else if (_selectedIndex == 999){
        _selectedImageView1.hidden = YES;
        _selectedImageView2.hidden = NO;
        _selectedImageView3.hidden = YES;
        _whiteBGView2.hidden = NO;
        _finishBtn.y = _whiteBGView2.maxY + 20;

    }else if(_selectedIndex == 888){
        _selectedImageView1.hidden = YES;
        _selectedImageView2.hidden = YES;
        _selectedImageView3.hidden = NO;
        _whiteBGView2.hidden = YES;
        _finishBtn.y = _whiteBGView1.maxY + 20;
    }
    [self checkFinishButonCanUse];
}

@end
