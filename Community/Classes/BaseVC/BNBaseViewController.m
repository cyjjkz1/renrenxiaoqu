//
//  BNBaseViewController.m
//
//  Created by BN on 14-10-24.
//  Copyright (c) 2014年 xjy. All rights reserved.
//

#import "BNBaseViewController.h"
#import "BNNavigationController.h"
#import "PublishViewController.h"
#import "cc_macro.h"
@interface BNBaseViewController ()
@property (nonatomic, readonly)UILabel *navigationLabel;
@property (nonatomic, assign)BOOL initialized;




@end

@implementation BNBaseViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)appearForFirstTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"AppearForFirstTime_%@_v5.0.0", NSStringFromClass(self.class)];
    BOOL result = [userDefaults boolForKey:key];
    if (!result) {
        [userDefaults setBool:YES forKey:key];
        [userDefaults synchronize];
    }
    return !result;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)initialize
{
    if (_initialized) {
        return;
    }
    _initialized = YES;

    self.view.backgroundColor = UIColorFromRGB(0xffffff); 
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //六十四像素的背景view
    _sixtyFourPixelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCCScreenWidth, NaviHeight)];
    _sixtyFourPixelsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _sixtyFourPixelsView.backgroundColor = UIColorFromRGB(0x0080ff);
    [self.view insertSubview:_sixtyFourPixelsView atIndex:1];
    //init custom navigation bar
    _customNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, kCCScreenWidth, 44)];
    _customNavigationBar.userInteractionEnabled = YES;
    _customNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_sixtyFourPixelsView addSubview:_customNavigationBar];
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, _customNavigationBar.frame.size.height-0.5, _customNavigationBar.frame.size.width, 0.5)];
//    line.tag = 10001;
//    line.backgroundColor = UIColor_GrayLine;
//    [_customNavigationBar addSubview:line];
    
    //title
    
    _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 120, 44)];
    _navigationLabel.tag = 10002;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin;
    _navigationLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    _navigationLabel.textColor = [UIColor whiteColor];
    _navigationLabel.text = _navigationTitle;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.textAlignment = NSTextAlignmentCenter;
    _navigationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_customNavigationBar addSubview:_navigationLabel];
    //back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 60, 44);
    _backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
//    [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -14)];
    [_customNavigationBar addSubview:_backButton];

    
    UIButton *telManager = [UIButton buttonWithType:UIButtonTypeCustom];
    telManager.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 70, 44);
    telManager.hidden = YES;
    [telManager setImage:[UIImage imageNamed:@"icon_sos"] forState:UIControlStateNormal];

    [telManager setTitleColor:BNColorRGB(255, 151, 0) forState:UIControlStateHighlighted];
    [telManager addTarget:self action:@selector(navigationRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:telManager];
    _telManagerBtn = telManager;
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    publishBtn.hidden = YES;
    [publishBtn setImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:publishBtn];
    _publishBtn = publishBtn;
}


- (void)setupLoadedView
{
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT- NaviHeight)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NaviHeight + 1);
    theScollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:theScollView belowSubview:self.sixtyFourPixelsView];
    
    self.baseScrollView = theScollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    

}


- (void)setNavigationTitle:(NSString *)navigationTitle
{
    if (![_navigationTitle isEqualToString:navigationTitle]) {
        _navigationTitle = navigationTitle;
        _navigationLabel.text = _navigationTitle;
    }
}

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        //防止多次连续点击崩溃
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar
{
    _showNavigationBar = showNavigationBar;
    _sixtyFourPixelsView.hidden = !_showNavigationBar;
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    [UIView animateWithDuration:.25 animations:^{
        if (hidden) {
            _sixtyFourPixelsView.transform = CGAffineTransformMakeTranslation(0, -64);
//            _sixtyFourPixelsView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        }
        else{
            _sixtyFourPixelsView.transform = CGAffineTransformMakeTranslation(0, 0);
//            _sixtyFourPixelsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        }
    }];
}

- (void)setNavigationTitleColor:(UIColor *)navigationTitleColor {
    _navigationLabel.textColor = navigationTitleColor;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - keyboard
- (void)addResponseKeyboardAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeResponseKeyboardAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillHidden:(NSNotification *)note
{
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
}
- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animated];
}
- (void)popToRootViewControllerAnimated:(BOOL)animated compliton:(void(^)(void))complitionBlock
{
   
   [self.navigationController popToRootViewControllerAnimated:animated];
    if (complitionBlock) {
        complitionBlock();
    }
}

- (void)navigationRightBtnAction:(UIButton *)btn
{
    
}

- (void)publishAcion
{
    PublishViewController *pubVC = [[PublishViewController alloc] init];
    
    [self pushViewController:pubVC animated:YES];
}

@end

