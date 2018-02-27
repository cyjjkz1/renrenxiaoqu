//
//  AppDelegate.m
//  Community
//
//  Created by liuchun on 16/6/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AppDelegate.h"
#import "BNMainViewController.h"
#import "BNWelcomeVC.h"
#import "LoginViewController.h"
#import "BNNavigationController.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OneKeyApi.h"
#import "QSWXApiManager.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initSVProgressHUD];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [WXApi registerApp:@"wx097d7911a342e500"];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    NSLog(@"****** window ****** %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    self.window.rootViewController = [self setRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateCurrentPageData object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url NS_DEPRECATED_IOS(2_0, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED
{
    [WXApi handleOpenURL:url delegate:[QSWXApiManager sharedManager]];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //发通知
            [kNotificationCenter postNotificationName:kNotification_chargeFinish object:nil];
        }];
    }else{
         [WXApi handleOpenURL:url delegate:[QSWXApiManager sharedManager]];
    }
    return YES;
}


- (UIViewController *)setRootViewController
{
    NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    float sandbox = [kUserDefaults floatForKey:kVersionKey];
    
    
    if (thisVersion.floatValue > sandbox) {
//        [kUserDefaults setFloat:thisVersion.floatValue forKey:kVersionKey];
        //欢迎页
        BNWelcomeVC *welcomeVC = [[BNWelcomeVC alloc] init];
        BNNavigationController *nav = [[BNNavigationController alloc] initWithRootViewController:welcomeVC];
        return nav;
    }
    
    UserInfo *user = UserInfo.sharedUserInfo;
    if (user.login) {
        BNMainViewController *mainVC = [[BNMainViewController alloc] init];
        return mainVC;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BNNavigationController *nav = [[BNNavigationController alloc] initWithRootViewController:loginVC];
        return nav;
    }
}

- (void)initSVProgressHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}



//注册YYlock
-(void)registerYYlock
{
    keyObject *keyModel = [[keyObject alloc]init];
    keyModel.deviceId = @"0304052D";
    keyModel.password = @"12345678";
    keyModel.RSSI = -100;
    keyModel.userId = @"88768321";
    
    keyObject *keyModel2 = [[keyObject alloc]init];
    keyModel2.deviceId = @"03040533";
    keyModel2.password = @"12345678";
    keyModel2.userId = @"88768322";
    keyModel2.RSSI = -100;
    
    keyObject *keyModel3 = [[keyObject alloc]init];
    keyModel3.deviceId = @"55BC4DA5";
    keyModel3.password = @"12345675";
    keyModel3.userId = @"88768324";
    keyModel3.RSSI = -90;
    
    keyObject *keyModel4 = [[keyObject alloc]init];
    keyModel4.deviceId = @"169E1633";
    keyModel4.password = @"12345678";
    keyModel4.userId = @"88768327";
    keyModel4.RSSI = -90;
    
    NSArray *keyArray = [NSArray arrayWithObjects:keyModel,keyModel2,keyModel3,keyModel4,nil];
    
    //获取单例
    OneKeyApi *yylockApi = [OneKeyApi shareInstance];
    
    //默认开启ibeanon
    yylockApi.isSuppertIbeacon =  YES;
    
    //初始化设备信息
    float devVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    [yylockApi registerDeviceWithMode:LOCK_MODE_AUTO andDeviceInfos:keyArray andNeedCmpRssi:YES supportBeacon:YES deviceVersion:devVersion];
}
@end
