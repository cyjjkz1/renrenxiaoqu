//
//  SettingViewController.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "AboutUSViewController.h"
#import "LoginViewController.h"
#import "BNNavigationController.h"
#import "KeychainItemWrapper.h"
#import "cc_macro.h"
#import "BNBaseWebViewController.h"
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@end

@implementation SettingViewController

static NSString *const settingCellID = @"settingCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"设置";
    
    [self setupLoadedView];
}


- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(13 * BILI_WIDTH, SCREEN_HEIGHT - 56 * BILI_WIDTH, SCREEN_WIDTH - 26 * BILI_WIDTH, 34 * BILI_WIDTH);
    [logoutBtn setuporangeBtnTitle:@"退出登录" enable:YES];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
    logoutBtn.layer.cornerRadius = 4 * BILI_WIDTH;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(logoutAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: logoutBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight + 8*BILI_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight - 56 * BILI_WIDTH - 8*BILI_WIDTH)];
    tableView.rowHeight = 40;
    tableView.sectionFooterHeight = 10;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview: tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[SettingCell class] forCellReuseIdentifier:settingCellID];
}


//退出登录
- (void)logoutAcion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认退出当前账号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 )return;
    //退出登录逻辑
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
    [keychain setObject:@" " forKey:(id)kSecValueData];
    
    //退出登录接口
    UserInfo *user = [UserInfo sharedUserInfo];
    user.login = NO;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    //切换window 的根试图控制器
    BNNavigationController *nav = [[BNNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    window.rootViewController = nav;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:YES];
    [UIView commitAnimations];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
    if(indexPath.section == 0){
        [cell showWithTitle:@"软件许可及服务协议"];
    }else if(indexPath.section == 1){
        [cell showWithTitle:@"关于我们"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //关于我们
//    AboutUSViewController *vc = [[AboutUSViewController alloc] init];
//    [self pushViewController:vc animated:YES];
    if(indexPath.section == 0){
        BNBaseWebViewController *protocolVC = [[BNBaseWebViewController alloc] init];
        protocolVC.urlString = @"https://www.sqguanjia.com/protocol.html";
        protocolVC.navTitle = @"软件许可及服务协议";
        [self pushViewController:protocolVC animated:YES];
    }else if(indexPath.section == 1){
        BNBaseWebViewController *protocolVC = [[BNBaseWebViewController alloc] init];
        protocolVC.urlString = @"https://www.sqguanjia.com/#contact";
        protocolVC.navTitle = @"关于我们";
        [self pushViewController:protocolVC animated:YES];
    }
}

@end
