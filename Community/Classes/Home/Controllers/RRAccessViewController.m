//
//  RRAccessViewController.m
//  Community
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "RRAccessViewController.h"
#import "UIView+YSKit.h"
#import "Macro.h"
#import "UIImage+Create.h"
#import "RRConfigViewController.h"
#import "RRAutoViewController.h"
#import "RRManualViewController.h"
@interface RRAccessViewController ()

@property (nonatomic, strong) UIButton *configAccessBtn;
@property (nonatomic, strong) UIButton *autoOpenBtn;
@property (nonatomic, strong) UIButton *manualOpenBtn;


@end

@implementation RRAccessViewController


#pragma mark -
#pragma mark GET
- (UIButton *)configAccessBtn
{
    if (_configAccessBtn == nil) {
        _configAccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _configAccessBtn.tag = 10000;
        [_configAccessBtn setTitle:@"门禁配置" forState:UIControlStateNormal];
        [_configAccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_configAccessBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configAccessBtn;
}

- (UIButton *)autoOpenBtn
{
    if (_autoOpenBtn == nil) {
        _autoOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _autoOpenBtn.tag = 20000;
        [_autoOpenBtn setTitle:@"自动开门" forState:UIControlStateNormal];
        [_autoOpenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_autoOpenBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoOpenBtn;
}

- (UIButton *)manualOpenBtn
{
    if (_manualOpenBtn == nil) {
        _manualOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _manualOpenBtn.tag = 30000;
        [_manualOpenBtn setTitle:@"手动配置" forState:UIControlStateNormal];
        [_manualOpenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manualOpenBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manualOpenBtn;
}


#pragma mark - 
#pragma mark
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 10000:
        {
            RRConfigViewController *configVC = [[RRConfigViewController alloc] init];
            [self pushViewController:configVC animated:YES];
        }
            break;

        case 20000:
        {
            RRAutoViewController *autoOpen = [[RRAutoViewController alloc] init];
            [self pushViewController:autoOpen animated:YES];
        }
            break;
            
        case 30000:
        {
            RRManualViewController *manualOpen = [[RRManualViewController alloc] init];
             [self pushViewController:manualOpen animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark life circle

- (void)addSubviewsToParentView
{
    [self.view addSubview:self.configAccessBtn];
    [self.view addSubview:self.autoOpenBtn];
    [self.view addSubview:self.manualOpenBtn];
}

- (void)layoutSubviews{
    CGFloat sin60 = sin(M_PI/3.0);
    self.configAccessBtn.frame = CGRectMake(SCREEN_WIDTH/4.0, self.customNavigationBar.bottom+40, SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0);
    self.autoOpenBtn.frame = CGRectMake(0, _configAccessBtn.top + SCREEN_WIDTH/4.0 + ((SCREEN_WIDTH/2.0)*sin60 - (SCREEN_WIDTH/4.0)), _configAccessBtn.width, _configAccessBtn.height);
    self.manualOpenBtn.frame = CGRectMake(_autoOpenBtn.right, _autoOpenBtn.top, _configAccessBtn.width, _configAccessBtn.height);
}

- (void)appendAttributeWithView
{
    [self.configAccessBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xD23834) size:CGSizeMake(_configAccessBtn.width*2, _configAccessBtn.height*2)] forState:UIControlStateNormal];
    [self.autoOpenBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0x1E944E) size:CGSizeMake(_autoOpenBtn.width*2, _autoOpenBtn.height*2)] forState:UIControlStateNormal];
    [self.manualOpenBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xFDC534) size:CGSizeMake(_manualOpenBtn.width*2, _manualOpenBtn.height*2)] forState:UIControlStateNormal];
    
    self.configAccessBtn.layer.cornerRadius = _configAccessBtn.width/2.0;
    self.autoOpenBtn.layer.cornerRadius = _autoOpenBtn.width/2.0;
    self.manualOpenBtn.layer.cornerRadius = _manualOpenBtn.width/2.0;
    
    self.configAccessBtn.layer.masksToBounds = YES;
    self.autoOpenBtn.layer.masksToBounds = YES;
    self.manualOpenBtn.layer.masksToBounds = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = @"门禁";
    
    [self addSubviewsToParentView];
    [self layoutSubviews];
    [self appendAttributeWithView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
