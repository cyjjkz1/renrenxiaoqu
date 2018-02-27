//
//  BNMainViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-21.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNMainViewController.h"
#import "BNNavigationController.h"
#import "HomeViewController.h"
#import "RSMainVC.h"
#import "PersonalViewController.h"
#import "MineViewController.h"
#import "BNNavigationController.h"
@interface BNMainViewController ()


@end

@implementation BNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}


- (void)setupSubViewController
{
    //首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    //租售
    RSMainVC *rsVC = [[RSMainVC alloc] init];
    
    //个人中心
    MineViewController  *personalCenterVC = [[MineViewController alloc] init];
//    PersonalViewController  *personalCenterVC = [[PersonalViewController alloc] init];

    
    
    BNNavigationController *oneCardSolutionNavi = [[BNNavigationController alloc]initWithRootViewController:homeVC];
    BNNavigationController *serviceNavi = [[BNNavigationController alloc]initWithRootViewController:rsVC];
    BNNavigationController *personalCenterNavi = [[BNNavigationController alloc]initWithRootViewController:personalCenterVC];



    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_tab_home"] selectedImage:[UIImage imageNamed:@"icon_tab_home_se"]];
    
    rsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"租售" image:[UIImage imageNamed:@"icon_tab_zushou"] selectedImage:[UIImage imageNamed:@"icon_tab_zushou_se"]];

    personalCenterVC.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_tab_mine"] selectedImage:[UIImage imageNamed:@"icon_tab_mine_se"]];

//    UIEdgeInsets edgeInset = UIEdgeInsetsMake(6, 0, -6, 0);
//    homeVC.tabBarItem.imageInsets = edgeInset;
//    serviceVC.tabBarItem.imageInsets = edgeInset;
//    personalCenterVC.tabBarItem.imageInsets = edgeInset;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: UIColorFromRGB(0x0080ff),NSForegroundColorAttributeName, nil];
    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateSelected];

//    [[UITabBar appearance] setSelectedImageTintColor: UIColorFromRGB(0x0080ff)];

    NSArray *viewControllers = @[oneCardSolutionNavi, serviceNavi, personalCenterNavi];
    self.viewControllers = viewControllers;
}


@end
