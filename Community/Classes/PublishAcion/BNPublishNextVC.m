//
//  BNPublishNextVC.m
//  Community
//
//  Created by mac1 on 16/8/25.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNPublishNextVC.h"
#import "PlaceholderTextView.h"
#import "LCPickerView.h"
#import "BNBaseTextField.h"
#import "HouseTypeModel.h"
#import "LCCustomButton.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BNUploadTools.h"
#import "LCUploadProgress.h"
#import "BNBaseWebViewController.h"
#import "cc_macro.h"
@interface BNPublishNextVC ()<LCPickerViewDataSouce, LCPickerViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *theScrollView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UIButton *individual;
@property (nonatomic, strong) UIButton *houseAgent;
@property (nonatomic, strong) BNBaseTextField *titleText;
@property (nonatomic, weak) LCPickerView *showingPickerView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) UIButton *publishButton;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) NSArray *defalutBtnTitle;
@property (nonatomic, strong) NSDictionary *saleDatas;
@property (nonatomic, copy) NSString *uploadPhotoId;

@property (nonatomic, assign) BOOL pickerShow;


@end

@implementation BNPublishNextVC


- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void)setType:(PublishType *)type
{
    _type = type;
    if ([type.text isEqualToString:@"房屋出售"]) {
        self.useType = BNPublishNextVCUseType_sale_house;
    }else if ([type.text isEqualToString:@"房屋出租"]){
        self.useType = BNPublishNextVCUseType_rent_house;
    }else if ([type.text isEqualToString:@"车位出售"]){
        self.useType = BNPublishNextVCUseType_sale_car;
    }else if ([type.text isEqualToString:@"车位出租"]){
        self.useType = BNPublishNextVCUseType_rent_car;
    }else if ([type.text isEqualToString:@"房屋求租"]){
        self.useType = PubForAskVCUseType_rent_house;
    }else if ([type.text isEqualToString:@"房屋求购"]){
        self.useType = PubForAskVCUseType_sale_house;
    }else if ([type.text isEqualToString:@"车位求购"]){
        self.useType = PubForAskVCUseType_sale_car;
    }else if ([type.text isEqualToString:@"车位求租"]){
        self.useType = PubForAskVCUseType_rent_car;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseSubViews];
    [self setOtherSubViews];
    [self initSomeDatas];
    self.pickerShow = NO;
    NSString *navTitle = @"";
    switch (self.useType) {
        case BNPublishNextVCUseType_sale_house: {
            navTitle = @"房屋出售";
            break;
        }
        case BNPublishNextVCUseType_rent_house: {
            navTitle = @"房屋出租";
            break;
        }
        case BNPublishNextVCUseType_sale_car: {
            navTitle = @"车位出售";
            break;
        }
        case BNPublishNextVCUseType_rent_car: {
            navTitle = @"车位出租";
            break;
        }
        case PubForAskVCUseType_sale_house: {
            navTitle = @"房屋求购";
            break;
        }
        case PubForAskVCUseType_rent_house: {
            navTitle = @"房屋求租";
            break;
        }
        case PubForAskVCUseType_sale_car: {
            navTitle = @"车位求购";
            break;
        }
        case PubForAskVCUseType_rent_car: {
            navTitle = @"车位求租";
            break;
        }
    }
    self.navigationTitle = navTitle;
    
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)setupBaseSubViews
{
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT- NaviHeight)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NaviHeight + 1);
    theScollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:theScollView];
    _theScrollView = theScollView;
    
    CGFloat originY = 0.0;
    CGFloat statusW = 55;
    //出售需要上传照片
    if (self.useType == BNPublishNextVCUseType_sale_house || self.useType == BNPublishNextVCUseType_rent_house || self.useType == BNPublishNextVCUseType_sale_car || self.useType == BNPublishNextVCUseType_rent_car) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 208)];
        imageView.image = [UIImage imageNamed:@"tjtp"];
        imageView.userInteractionEnabled = YES;
        [theScollView addSubview:imageView];
        _imageView = imageView;
        originY += imageView.h;
        
        statusW = 40;
        
        UITapGestureRecognizer *addPhotoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoAction)];
        [imageView addGestureRecognizer:addPhotoGesture];
        
    }
    
    UIColor *temColor = UIColorFromRGB(0x6c6c6c);
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(16 * BILI_WIDTH, originY, statusW, 40)];
    status.textColor = temColor;
    status.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    status.text = @"身份";
    [theScollView addSubview:status];
    
    UIButton *individual = [UIButton buttonWithType:UIButtonTypeCustom];
    individual.frame = CGRectMake(status.maxX, status.y, 78*BILI_WIDTH, status.h);
    [individual setImage:[UIImage imageNamed:@"yuan_unselected"] forState:UIControlStateNormal];
    [individual setImage:[UIImage imageNamed:@"yuan_selected"]  forState:UIControlStateSelected];
    [individual setTitle:@"个人" forState:UIControlStateNormal];
    [individual setTitleColor:temColor forState:UIControlStateNormal];
    individual.titleLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    individual.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    individual.selected = YES;
    [individual addTarget: self action:@selector(individualAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:individual];
    _individual = individual;
    
    UIButton *houseAgent = [UIButton buttonWithType:UIButtonTypeCustom];
    houseAgent.frame = CGRectMake(individual.maxX + 45*BILI_WIDTH, status.y, 78*BILI_WIDTH, status.h);
    [houseAgent setImage:[UIImage imageNamed:@"yuan_unselected"] forState:UIControlStateNormal];
    [houseAgent setImage:[UIImage imageNamed:@"yuan_selected"]  forState:UIControlStateSelected];
    [houseAgent setTitle:@"房产经纪人" forState:UIControlStateNormal];
    [houseAgent setTitleColor:temColor forState:UIControlStateNormal];
    houseAgent.titleLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    houseAgent.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [houseAgent addTarget: self action:@selector(individualAcion:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:houseAgent];
    _houseAgent = houseAgent;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, status.maxY - 0.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = UIColor_GrayLine;
    [theScollView addSubview:line1];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16*BILI_WIDTH, line1.maxY, statusW, 40)];
    title.textColor = temColor;
    title.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    title.text = @"标题";
    [theScollView addSubview:title];
    
    BNBaseTextField *titleText = [[BNBaseTextField alloc] initWithFrame:CGRectMake(status.maxX, title.y, SCREEN_WIDTH - status.maxX, 40)];
    titleText.placeholder = @"请输入标题";
    titleText.font = [UIFont systemFontOfSize:12];
    [theScollView addSubview:titleText];
    _titleText = titleText;
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, title.maxY - 0.5, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = UIColor_GrayLine;
    [theScollView addSubview:line2];
}

- (void)setOtherSubViews
{
    UIColor *temColor = UIColorFromRGB(0x6c6c6c);
    CGFloat originY = CGRectGetMaxY(self.titleText.frame);
    CGFloat itemHeight = 40;
    CGFloat lastMaY = originY;
    
    NSArray *titles;
    switch (self.useType) {
        case BNPublishNextVCUseType_sale_house: {
            titles = @[@"户型", @"装修", @"朝向",@"售价",@"描述",@"地址"];
            self.defalutBtnTitle = @[@"请选择户型",@"请选择装修",@"请选择朝向"];
            break;
        }
        case BNPublishNextVCUseType_rent_house: {
            titles = @[@"户型", @"装修", @"朝向",@"支付",@"租金",@"描述",@"地址"];
            self.defalutBtnTitle = @[@"请选择户型",@"请选择装修",@"请选择朝向",@"请选择支付方式"];
            break;
        }
        case BNPublishNextVCUseType_sale_car: {
            titles = @[@"售价",@"描述",@"地址"];
            self.defalutBtnTitle = @[];
            break;
        }
        case BNPublishNextVCUseType_rent_car: {
            titles = @[@"支付",@"租金",@"描述",@"地址"];;
            self.defalutBtnTitle = @[@"请选择支付方式"];
            break;
        }
        case PubForAskVCUseType_sale_house: {
            titles = @[@"期望户型", @"期望装修", @"期望朝向",@"期望售价",@"描述"];
            self.defalutBtnTitle = @[@"请选择期望户型",@"请选择期望装修",@"请选择期望朝向"];
            break;
        }
        case PubForAskVCUseType_rent_house: {
            titles = @[@"期望户型", @"期望装修", @"期望朝向",@"期望支付",@"期望租金",@"描述"];
            self.defalutBtnTitle = @[@"请选择期望户型",@"请选择期望装修",@"请选择期望朝向",@"请选择期望支付方式"];
            
            break;
        }
        case PubForAskVCUseType_sale_car: {
            titles = @[@"期望售价",@"描述"];
            self.defalutBtnTitle = @[];
            break;
        }
        case PubForAskVCUseType_rent_car: {
            titles = @[@"期望支付",@"期望租金",@"描述"];
            self.defalutBtnTitle = @[@"请选期望支付方式"];
            break;
        }
    }
  
    NSArray *placeholders = @[@"请输入描述",@"请输入地址"];
    
    CGFloat titleWidth = 0.0;
    if (self.useType == BNPublishNextVCUseType_sale_house || self.useType == BNPublishNextVCUseType_rent_house || self.useType == BNPublishNextVCUseType_sale_car || self.useType == BNPublishNextVCUseType_rent_car) {
        titleWidth = 40;
    }else{
        titleWidth = 55;
    }
    
    NSInteger startI = self.defalutBtnTitle.count;
    for (int i = 0; i < titles.count; i ++) {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16*BILI_WIDTH, lastMaY, titleWidth, itemHeight)];
        titleLabel.textColor = temColor;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.text = titles[i];
        [self.theScrollView addSubview:titleLabel];
        
        NSString *textPlaceholder = @"";
        if(self.useType == BNPublishNextVCUseType_sale_house || self.useType == BNPublishNextVCUseType_sale_car) {
            textPlaceholder = @"请输入售价(元)";
        }else if (self.useType == BNPublishNextVCUseType_rent_house || self.useType == BNPublishNextVCUseType_rent_car){
           textPlaceholder = @"请输入租金(元)";
        }else if (self.useType == PubForAskVCUseType_sale_house || self.useType == PubForAskVCUseType_sale_car){
            textPlaceholder = @"请输入期望售价(元)";
        }else{
            textPlaceholder = @"请输入期望租金(元)";
        }
        
        //右边的东西
        if (i < startI) {
            LCCustomButton *button = [LCCustomButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(titleLabel.maxX + 20, lastMaY, SCREEN_WIDTH - titleLabel.maxX, itemHeight);
            [button setTitle:_defalutBtnTitle[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.tag = i+1; //（1、2、3）
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.theScrollView addSubview:button];
            lastMaY += button.h;
        }else if (i == startI){
            BNBaseTextField *monText = [[BNBaseTextField alloc] initWithFrame:CGRectMake(titleLabel.maxX, lastMaY, SCREEN_WIDTH - titleLabel.maxX, itemHeight)];
            monText.placeholder = textPlaceholder;
            monText.tag = i + 1;// (4)
            monText.delegate = self;
            monText.keyboardType = UIKeyboardTypeNumberPad;
            [monText addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
            monText.font = [UIFont systemFontOfSize:12];
            [self.theScrollView addSubview:monText];
            lastMaY += monText.h;
        }else{
            PlaceholderTextView *textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(titleLabel.maxX + 18, lastMaY + 5, SCREEN_WIDTH - titleLabel.maxX, 80)];
            textView.placeholder = placeholders[i - startI - 1];
            textView.placeholderColor = [UIColor lightGrayColor];
            textView.tag = i + 1; //（5、6）
            [self.theScrollView addSubview:textView];
            lastMaY += textView.h;
        }
        
        //横线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lastMaY - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.theScrollView addSubview:line];

        
    }
    
    //发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(16*BILI_WIDTH, lastMaY + 30, SCREEN_WIDTH - 32 * BILI_WIDTH, 40);
    [publishBtn setuporangeBtnTitle:@"发布" enable:YES];
    [publishBtn addTarget:self action:@selector(publishAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:publishBtn];
    _publishButton = publishBtn;
    
    originY = publishBtn.maxY + 15;
    
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeButton.tag = 103;
    _agreeButton.frame = CGRectMake(15 * BILI_WIDTH, originY-4*BILI_WIDTH, 20*BILI_WIDTH, 20*BILI_WIDTH);
    _agreeButton.imageEdgeInsets = UIEdgeInsetsMake(2*BILI_WIDTH, 0, 2*BILI_WIDTH, 4*BILI_WIDTH);
    [_agreeButton addTarget:self action:@selector(agreeButtonAcion) forControlEvents:UIControlEventTouchUpInside];
    [_agreeButton setImage:[UIImage imageNamed:@"SignInVC_UnSelectedBtn"] forState:UIControlStateNormal];
    [_agreeButton setImage:[UIImage imageNamed:@"SignInVC_SelectedBtn"] forState:UIControlStateSelected];
    [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_agreeButton setTitleColor:LoginVC_OrengeBtn_textColor_HighLight forState:UIControlStateHighlighted];
    _agreeButton.layer.cornerRadius = 3;
    _agreeButton.layer.masksToBounds = YES;
    [self.theScrollView addSubview:_agreeButton];
    _agreeButton.selected = YES;
    
    UILabel *agreeLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_agreeButton.frame), originY, 130*BILI_WIDTH, 13*BILI_WIDTH)];
    agreeLbl.textColor = [UIColor grayColor];
    agreeLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    [self.theScrollView addSubview:agreeLbl];
    agreeLbl.text = @"已阅读";
    CGFloat textWidth = [Tools getTextWidthWithText:@"已阅读" font:agreeLbl.font height:agreeLbl.frame.size.height];
    agreeLbl.frame = CGRectMake(agreeLbl.frame.origin.x, agreeLbl.frame.origin.y, textWidth, agreeLbl.frame.size.height);
    
    self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readButton addTarget:self action:@selector(readButtonAcion) forControlEvents:UIControlEventTouchUpInside];
    [_readButton setTitle:@"发布协议" forState:UIControlStateNormal];
    [_readButton setTitleColor:UIColor_Button_Normal forState:UIControlStateNormal];
    [_readButton setTitleColor:UIColor_Button_HighLight forState:UIControlStateHighlighted];
    _readButton.titleLabel.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    CGFloat redTextWidth = [Tools getTextWidthWithText:@"发布协议" font:agreeLbl.font height:agreeLbl.frame.size.height];
    _readButton.frame = CGRectMake(CGRectGetMaxX(agreeLbl.frame)+5, originY, redTextWidth+10*BILI_WIDTH, 13*BILI_WIDTH);
    
    _readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _readButton.layer.cornerRadius = 3;
    _readButton.layer.masksToBounds = YES;
    [self.theScrollView addSubview:_readButton];

    
    
    //修改scorllView的contentSize
    CGFloat maxY = _readButton.maxY + 30;
    if (maxY > self.theScrollView.contentSize.height) {
        self.theScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, maxY);
    }

}

- (void)initSomeDatas
{
    
//    NSArray *rooms = @[@"套一",@"套二",@"套三",@"套四及以上"];
//    NSArray *decorates = @[@"清水",@"简装",@"精装",@"豪装"];
//    NSArray *directions = @[@"东",@"西",@"南",@"北"];
//    NSArray *payStyles = @[@"押一付一",@"押一付三",@"一年起租"];
    
    switch (self.useType) {
        case BNPublishNextVCUseType_sale_house:
        case PubForAskVCUseType_sale_house:
        {
            self.saleDatas = @{@"1":self.houseTypes, @"2":self.decorationTypes, @"3":self.directions};
            break;
        }
        case BNPublishNextVCUseType_rent_house:
        case PubForAskVCUseType_rent_house:
        {
            self.saleDatas = @{@"1":self.houseTypes, @"2":self.decorationTypes, @"3":self.directions,@"4":self.payTypes};
            break;
        }
        case BNPublishNextVCUseType_sale_car:
        case PubForAskVCUseType_sale_car:
        {
            self.saleDatas = @{};
            break;
        }
        case BNPublishNextVCUseType_rent_car:
        case PubForAskVCUseType_rent_car:
        {
            self.saleDatas = @{@"1":self.payTypes};
            break;
        }
    }

  
   
}

- (void)buttonClick:(LCCustomButton *)btn
{
    NSString *btnTag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    CGFloat pickerItmH = 30;
    NSArray *arr =  self.saleDatas[btnTag];
    CGFloat pickerH = pickerItmH * arr.count;
    
    if (_showingPickerView) {
        [_showingPickerView dismissPickerView];
    }
    
    
    LCPickerView *pickerView = [[LCPickerView alloc] initWithFrame:CGRectMake(0,  SCREEN_HEIGHT - pickerH - 40, SCREEN_WIDTH, pickerH + 40)];
    pickerView.tag = 10 * btn.tag;
    pickerView.backgroundColor = [UIColor lightGrayColor];
    pickerView.delegate = self;
    pickerView.dataSouce = self;
    [pickerView setSelectedRow:0 inComponent:1];
    if (self.pickerShow == NO) {
        self.pickerShow = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             UIView *kkView = self.theScrollView;
                             self.theScrollView.frame = CGRectMake(kkView.x, kkView.y, kkView.w, SCREEN_HEIGHT -NaviHeight - pickerView.h-2);
                         }];
    }
    
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
    NSString *tag = [NSString stringWithFormat:@"%ld",pickerView.tag/10];
    NSArray *models = [self.saleDatas valueForKey:tag];
    
    return models.count;

}

- (HouseTypeModel *)myPickerView:(LCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSString *tag = [NSString stringWithFormat:@"%ld",pickerView.tag/10];
    NSArray *models = [self.saleDatas valueForKey:tag];
    
    return models[row];
}


#pragma mark LCPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger btnTag = pickerView.tag / 10;
    
    LCCustomButton *button = (LCCustomButton *)[self.theScrollView viewWithTag:btnTag];
    button.selected = YES;
    NSArray *models = self.saleDatas[[NSString stringWithFormat:@"%ld",(long)btnTag]];
    HouseTypeModel *model = models[row];
    button.model = model;
    [UIView animateWithDuration:0.3
                     animations:^{
                         UIView *kkView = self.theScrollView;
                         self.theScrollView.frame = CGRectMake(kkView.x, kkView.y, kkView.w, kkView.h + pickerView.h);
                     } completion:^(BOOL finished) {
                         self.pickerShow = NO;
                     }];
}

- (void)pickerViewDidCancel:(LCPickerView *)pickerView
{
    NSInteger btnTag = pickerView.tag / 10;
    LCCustomButton *button = [self.theScrollView viewWithTag:btnTag];
    button.selected = NO;
    [button setTitle:_defalutBtnTitle[btnTag-1] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3
                     animations:^{
                         UIView *kkView = self.theScrollView;
                         self.theScrollView.frame = CGRectMake(kkView.x, kkView.y, kkView.w, kkView.h + pickerView.h);
                     } completion:^(BOOL finished) {
                         self.pickerShow = NO;
                     }];
    _showingPickerView = nil;
}


- (void)individualAcion:(UIButton *)button
{
    if (button.isSelected == YES) {
        return;
    }
    
    if (button == _individual) {
        button.selected = YES;
        _houseAgent.selected = NO;
    }else{
        button.selected = YES;
        _individual.selected = NO;
    }
    
}

//发布按钮
- (void)publishAcion
{
    //文章类型
    NSString *articleType = self.type.sortNo;
//    NSString *titleType = _houseAgent.isSelected ? @"房产经纪人" : @"个人";
    NSString *title = _titleText.text;
    NSString *houseType = @""; //户型
    NSString *decorationType = @""; //装修
    NSString *direction = @""; //朝向
    NSString *payType = @""; //支付方式
    NSString *price = @""; //售价
    NSString *desp = @""; //描述
    NSString *address = @""; //地址
    
    switch (self.useType) {
        case BNPublishNextVCUseType_sale_house: {
//            articleType = @"房屋出售";
            LCCustomButton *houseTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            houseType = houseTypeBtn.model.sortNo;
            
            LCCustomButton *decorationTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:2];
            decorationType = decorationTypeBtn.model.sortNo;
            
            LCCustomButton *directionBtn = (LCCustomButton *)[self.theScrollView viewWithTag:3];
            direction = directionBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:4];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:5];
            desp = despText.text;
            
            PlaceholderTextView *addressText = (PlaceholderTextView *)[self.theScrollView viewWithTag:6];
            address = addressText.text;
            
            break;
        }
        case BNPublishNextVCUseType_rent_house: {
//            articleType = @"房屋出租";
            LCCustomButton *houseTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            houseType = houseTypeBtn.model.sortNo;
            
            LCCustomButton *decorationTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:2];
            decorationType = decorationTypeBtn.model.sortNo;
            
            LCCustomButton *directionBtn = (LCCustomButton *)[self.theScrollView viewWithTag:3];
            direction = directionBtn.model.sortNo;
            
            LCCustomButton *payTpyeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:4];
            payType = payTpyeBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:5];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:6];
            desp = despText.text;
            
            PlaceholderTextView *addressText = (PlaceholderTextView *)[self.theScrollView viewWithTag:7];
            address = addressText.text;
            
            break;
        }
        case BNPublishNextVCUseType_sale_car: {
//            articleType = @"车位出售";
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:1];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:2];
            desp = despText.text;
            
            PlaceholderTextView *addressText = (PlaceholderTextView *)[self.theScrollView viewWithTag:3];
            address = addressText.text;

            break;
        }
        case BNPublishNextVCUseType_rent_car: {
//            articleType = @"车位出租";
            
            LCCustomButton *payTpyeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            payType = payTpyeBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:2];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:3];
            desp = despText.text;
            
            PlaceholderTextView *addressText = (PlaceholderTextView *)[self.theScrollView viewWithTag:4];
            address = addressText.text;

            break;
        }
        case PubForAskVCUseType_sale_house: {
//            articleType = @"房屋求购";
            LCCustomButton *houseTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            houseType = houseTypeBtn.model.sortNo;
            
            LCCustomButton *decorationTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:2];
            decorationType = decorationTypeBtn.model.sortNo;
            
            LCCustomButton *directionBtn = (LCCustomButton *)[self.theScrollView viewWithTag:3];
            direction = directionBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:4];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:5];
            desp = despText.text;
            
            break;
        }
        case PubForAskVCUseType_rent_house: {
//            articleType = @"房屋求租";
            LCCustomButton *houseTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            houseType = houseTypeBtn.model.sortNo;
            
            LCCustomButton *decorationTypeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:2];
            decorationType = decorationTypeBtn.model.sortNo;
            
            LCCustomButton *directionBtn = (LCCustomButton *)[self.theScrollView viewWithTag:3];
            direction = directionBtn.model.sortNo;
            
            LCCustomButton *payTpyeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:4];
            payType = payTpyeBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:5];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:6];
            desp = despText.text;
            
            break;
        }
        case PubForAskVCUseType_sale_car: {
//            articleType = @"车位求购";
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:1];
            price = priceText.text;
            
            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:2];
            desp = despText.text;
            
            break;
        }
        case PubForAskVCUseType_rent_car: {
//            articleType = @"车位求租";
            
            LCCustomButton *payTpyeBtn = (LCCustomButton *)[self.theScrollView viewWithTag:1];
            payType = payTpyeBtn.model.sortNo;
            
            BNBaseTextField *priceText = (BNBaseTextField*)[self.theScrollView viewWithTag:2];
            price = priceText.text;

            PlaceholderTextView *despText = (PlaceholderTextView *)[self.theScrollView viewWithTag:3];
            desp = despText.text;
            
            break;
        }
    }
    
    //file暂时传nil
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi createRentAndBuyInfoWithUserId:[UserInfo sharedUserInfo].userId
                                     houseType:houseType
                                     direction:direction
                                       payType:payType
                                   consultType:nil
                                decorationType:decorationType
                                         title:title
                                   articleType:articleType
                                     titleType:articleType
                                         price:price
                                          desp:desp
                                       address:address
                                         files:nil
                                       photoId:self.uploadPhotoId
                                       success:^(NSDictionary *successData) {
                                           NSLog(@"发布信息--->>>>%@",successData);
                                           if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                               [SVProgressHUD showSuccessWithStatus:@"发布成功！"];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }else{
                                               NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                               [SVProgressHUD showErrorWithStatus:retMsg];
                                           }
                                       }
                                        failed:^(NSError *error) {
                                            NSLog(@"发布信息--->>>>%@",error);
                                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                        }];
}


//监听键盘弹出
- (void)keyboardWillShow:(NSNotification *)noti
{
    
    if(_showingPickerView){
        [_showingPickerView dismissPickerView];
        _showingPickerView = nil;
    }
}

#pragma mark - Add Photo
- (void)addPhotoAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择上传照片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    // 0 相机  1 相册
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil] show];
        return;
    }
    
    _imagePicker = [[UIImagePickerController alloc]  init];
    _imagePicker.sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if (buttonIndex == 0) {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    _imagePicker.allowsEditing=YES;//允许编辑
    _imagePicker.delegate = self;//设置代理，检测操作
    [self presentViewController:_imagePicker animated:YES completion:nil];

}


#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {//如果是照片
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing)
        {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }
        else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
//        image=[info objectForKey:UIImagePickerControllerOriginalImage];
        _imageView.image = image;
        
        LCUploadProgress *progressView = [[LCUploadProgress alloc] initWithFrame:_imageView.frame];
        progressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_theScrollView addSubview:progressView];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        __weak typeof(self) weakSelf = self;
        [[BNUploadTools shareInstance] uploadImageWithData:imageData
                                                   success:^(id responseObject) {
                                                       if ([[responseObject valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                           NSLog(@"发布上传照片--->>>>%@",responseObject);
                                                           [SVProgressHUD showSuccessWithStatus:@"添加照片成功"];
                                                           [progressView removeFromSuperview];
                                                           weakSelf.uploadPhotoId = [NSString stringWithFormat:@"%@",[responseObject valueNotNullForKey:@"data"]];
                                                        
                                                       }else{
                                                            [SVProgressHUD showErrorWithStatus:responseObject[kRequestRetMessage]];
                                                           [progressView removeFromSuperview];
                                                           _imageView.image = nil;
                                                       }
                                                   }
                                                  progress:^(NSProgress *progress){
                                                       NSLog(@"进度--->>>>%f",progress.fractionCompleted);
                                                      progressView.progress = progress;
                                                      
                                                  }failure:^(NSError *error) {
                                                      NSLog(@"upload image error --->>>>> %@",error);
                                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                      [progressView removeFromSuperview];
                                                      _imageView.image = nil;
                                                  }];
        
    }
    _imagePicker = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma markt - 输入框限制
- (void)textAction:(BNBaseTextField *)textField
{
    // 输入框限制
    NSString *str = textField.text;
    if ([str isEqualToString:@"."])
    {
        str = @"";
    }
    else if([str hasPrefix:@"0"] && str.length ==2 )
    {
        if ([str isEqualToString:@"0."])
        {
            return;
        }
        str = [NSString stringWithFormat:@"%ld",(long)[str integerValue]];
    }
    
    else {
        NSString *findStr = @".";
        NSRange foundObj=[str rangeOfString:findStr options:NSCaseInsensitiveSearch];
        if(foundObj.length>0)
        {
            if (str.length > foundObj.location + 3)
            {
                str = [str substringWithRange:NSMakeRange(0, foundObj.location + 3)];
            }
        }
        NSInteger pointCount = [[str componentsSeparatedByString:@"."] count]-1;
        //pointCount为str中“.“的个数。
        if(pointCount > 1) {
            str = [str substringWithRange:NSMakeRange(0, str.length-1)];
        }
    }
    textField.text = str;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不允许空格
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}


- (void)agreeButtonAcion
{
    _agreeButton.selected = !_agreeButton.selected;
    if (_agreeButton.isSelected) {
        _publishButton.enabled = YES;
    }else{
        _publishButton.enabled = NO;
    }
}

//阅读发布协议额
- (void)readButtonAcion{
    
    BNBaseWebViewController *protocolVC = [[BNBaseWebViewController alloc] init];
    protocolVC.urlString = [[NSBundle mainBundle] pathForResource:@"publish_protocal" ofType:@"html"];
    protocolVC.navTitle = @"协议";
    [self pushViewController:protocolVC animated:YES];
}


@end
