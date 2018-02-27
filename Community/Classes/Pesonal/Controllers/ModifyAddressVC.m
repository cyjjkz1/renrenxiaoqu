//
//  ModifyAddressVC.m
//  Community
//
//  Created by mac1 on 2016/11/13.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ModifyAddressVC.h"
#import "LCPickerView.h"

@interface ModifyAddressVC ()<LCPickerViewDelegate, LCPickerViewDataSouce>

@property (nonatomic, strong) NSArray *placeholds;
@property (nonatomic, strong) NSMutableArray *houseNumber;

@property (nonatomic, weak) UIButton *finishBtn;
@property (nonatomic, weak) LCPickerView *showingPickerView;


@end

@implementation ModifyAddressVC

- (NSMutableArray *)houseNumber
{
    if (!_houseNumber) {
        _houseNumber = @[].mutableCopy;
    }
    return _houseNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoadedView];
    
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    self.navigationTitle = @"小区";
    CGFloat originY = 0.0;
    NSArray *titles = @[@"楼宇", @"门牌号"];
    self.placeholds = @[@"请选择楼宇", @"请选择门牌号"];
    for (int i = 0; i < 2; i ++) {
        UILabel *leftTit = [[UILabel alloc] initWithFrame:CGRectMake(10, originY + 45 * i, 64, 45)];
        leftTit.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        leftTit.text = titles[i];
        //        leftTit.backgroundColor = [UIColor redColor];
        leftTit.textColor = [UIColor blackColor];
        [self.baseScrollView addSubview:leftTit];
        
        UIButton *placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        placeBtn.frame = CGRectMake(leftTit.maxX + 10, leftTit.y, SCREEN_WIDTH - leftTit.maxX - 10, leftTit.h);
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        placeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        placeBtn.tag = i + 1;
        [placeBtn setTitle:self.placeholds[i] forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.baseScrollView addSubview:placeBtn];
        [placeBtn addTarget:self action:@selector(prePickerView:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, originY+44.5 * (i + 1), SCREEN_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.baseScrollView addSubview:line];
        
        if (i == 1) {
            originY = placeBtn.maxY + 20;
        }
        
    }
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(10,originY, SCREEN_WIDTH - 20, 40);
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
        UIButton *buildingBtn = (UIButton *)[self.baseScrollView viewWithTag:1];
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
    
    UIButton *button = (UIButton *)[self.baseScrollView viewWithTag:btnTag];
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
    UIButton *button = [self.baseScrollView viewWithTag:btnTag];
    button.selected = NO;
    [button setTitle:self.placeholds[btnTag-1] forState:UIControlStateNormal];
    
    _showingPickerView = nil;
    [self checkFinishButonCanUse];
}

- (void)checkFinishButonCanUse
{
    UIButton *budingBtn = [self.baseScrollView viewWithTag:1];
    UIButton *houseNumberBtn = [self.baseScrollView viewWithTag:2];
    NSString *buding = budingBtn.titleLabel.text;
    NSString *houseNum = houseNumberBtn.titleLabel.text;
    NSString *placeholders1 = [self.placeholds objectAtIndex:0];
    NSString *palceholders2 = [self.placeholds objectAtIndex:1];
    
    if (![buding isEqualToString:placeholders1] && ![houseNum isEqualToString:palceholders2]) {
        _finishBtn.enabled = YES;
    }else{
        _finishBtn.enabled = NO;
    }
}

//完成按钮
- (void)buttonAcion:(UIButton *)button
{
    UIButton *budingBtn = [self.baseScrollView viewWithTag:1];
    UIButton *houseNumberBtn = [self.baseScrollView viewWithTag:2];
    NSString *buding = budingBtn.titleLabel.text;
    NSString *houseNum = houseNumberBtn.titleLabel.text;
    
    [RequestApi modifyAddressWithUserId:[UserInfo sharedUserInfo].userId
                           buildingName:buding
                               roomName:houseNum
                                success:^(NSDictionary *successData) {
                                    NSLog(@"修改地址---->>>>>%@",successData);
                                    if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                        UserInfo *user = [UserInfo sharedUserInfo];
                                        user.villige = [NSString stringWithFormat:@"%@-%@",buding,houseNum];
                                        self.editFinishBlock(buding, houseNum);
                                    }else{
                                        NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                    }
                                }
                                 failed:^(NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];;
    
}


@end
