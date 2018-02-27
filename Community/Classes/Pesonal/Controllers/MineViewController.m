//
//  MineViewController.m
//  Community_http
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 boen. All rights reserved.
//

#import "MineViewController.h"
#import "KeychainItemWrapper.h"
#import "PesonalCell.h"
#import "AccountInfoViewController.h"
#import "MyPublishMainVC.h"
#import "MsgMainVC.h"
#import "cc_macro.h"
#import "SDQViewController.h"
#import "SDQFeeDetialViewController.h"
#import "AccountInfoViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *identifyLabel;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MineViewController

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        if ([[UserInfo sharedUserInfo].status isEqualToString:@"业主"]) {
            _dataArray = @[@{@"imageName":@"icon_sdq",
                             @"title":@"我的水电气",
                             @"skipController": @"SDQViewController"
                             },@{
                               @"imageName":@"icon_mine_wuyefee",
                               @"title":@"我的物业费",
                               @"skipController": @"SDQFeeDetialViewController"
                               },@{
                               @"imageName":@"icon_mine_publish",
                               @"title":@"我的发布",
                               @"skipController": @"MyPublishMainVC"
                               },@{
                               @"imageName":@"icon_shoucang",
                               @"title":@"收藏",
                               @"skipController": @"MyCollectionVC"
                               },@{
                               @"imageName":@"icon_mine_zuhu",
                               @"title":@"住户管理",
                               @"skipController": @"RenterMangeVC"
                               },@{
                               @"imageName":@"icon_mine_wuguan",
                               @"title":@"我的物管",
                               @"skipController": @"AboutWuyeVC"
                               },@{
                               @"imageName": @"icon_setting",
                               @"title": @"设置",
                               @"skipController": @"SettingViewController"
                               }];
        }else{
            _dataArray = @[@{
                               @"imageName":@"icon_mine_publish",
                               @"title":@"我的发布",
                               @"skipController": @"MyPublishMainVC"
                               },
                           @{
                               @"imageName":@"icon_shoucang",
                               @"title":@"收藏",
                               @"skipController": @"MyCollectionVC"
                               },
                           @{
                               @"imageName": @"icon_setting",
                               @"title": @"设置",
                               @"skipController": @"SettingViewController"
                               }];
            
        }
        
    }
    return _dataArray;
}

static NSString *const PSCellID = @"PSCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationController.navigationBar.hidden = YES;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - TabbarHeight)];
    table.rowHeight = 40 * BILI_WIDTH;
    table.backgroundColor = UIColor_Gray_BG;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview: table];
    _tableView = table;
    [self.tableView registerClass:[PesonalCell class] forCellReuseIdentifier:PSCellID];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self setupHeadView];
    
    [self requestUserInfo];
}
- (void)setupHeadView
{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCCScreenWidth, 160 * BILI_WIDTH + NaviHeight)];

    headview.backgroundColor = UIColorFromRGB(0x0080ff);
    UIImageView *headBGImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_top"]];
    headBGImg.frame = CGRectMake(0, NaviHeight, kCCScreenWidth, 160 * BILI_WIDTH);
    [headview addSubview:headBGImg];
    
    
    UILabel *middleTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBarHeight, kCCScreenWidth, 44)];
    middleTitle.text = @"我的";
    middleTitle.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    middleTitle.backgroundColor = [UIColor clearColor];
    middleTitle.textColor = [UIColor whiteColor];
    middleTitle.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:middleTitle];

    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(kCCScreenWidth - 70, StatusBarHeight, 70, 44);
    [messageBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:messageBtn];
    [messageBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableHeaderView = headview;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kCCScreenWidth - 80 * BILI_WIDTH)/2.0, NaviHeight + 10 * BILI_WIDTH, 80 * BILI_WIDTH, 80 * BILI_WIDTH)];
    imgView.layer.cornerRadius = 40 * BILI_WIDTH;
    imgView.layer.masksToBounds = YES;
    [imgView setImage:[UIImage imageNamed:@"icon_default_head"]];
    [headview addSubview:imgView];
    self.headImageView = imgView;
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.maxY, kCCScreenWidth, 30 * BILI_WIDTH)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [UserInfo sharedUserInfo].userName;
    nameLabel.font = [UIFont boldSystemFontOfSize:15 * BILI_WIDTH];
    self.nameLabel = nameLabel;
    [headview addSubview:nameLabel];
    
    UILabel *identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCCScreenWidth/2.0 + 60, imgView.maxY + 5 * BILI_WIDTH, 52, 20 * BILI_WIDTH)];
    identifyLabel.textAlignment = NSTextAlignmentCenter;
    identifyLabel.textColor = UIColorFromRGB(0x0080ff);
    identifyLabel.text = [UserInfo sharedUserInfo].status;
    identifyLabel.layer.cornerRadius = 6.0;
    identifyLabel.layer.masksToBounds = YES;
    identifyLabel.backgroundColor = [UIColor whiteColor];
    identifyLabel.font = [UIFont boldSystemFontOfSize:13 * BILI_WIDTH];
    self.identifyLabel = identifyLabel;
    [headview addSubview:identifyLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.maxY, kCCScreenWidth, 30 * BILI_WIDTH)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.text = [UserInfo sharedUserInfo].phoneNumber.length == 11 ?
                      [[UserInfo sharedUserInfo].phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] :
                      [UserInfo sharedUserInfo].phoneNumber;
    phoneLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
    self.phoneLabel = phoneLabel;
    [headview addSubview:phoneLabel];
    
    UIButton *mineInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mineInfoBtn.frame = CGRectMake(0, NaviHeight, kCCScreenWidth, 160 * BILI_WIDTH);
    mineInfoBtn.backgroundColor = [UIColor clearColor];
    [headview addSubview:mineInfoBtn];
    [mineInfoBtn addTarget:self action:@selector(goUserInfo) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserInfo];
    
    
}
- (void)goUserInfo{
    if (![UserInfo sharedUserInfo].hasGetProfile) {
        [SVProgressHUD showErrorWithStatus:@"用户信息刷新中，请稍后再试!"];
        return;
    }
    AccountInfoViewController *accountVC = [[AccountInfoViewController alloc] init];
    [self.navigationController pushViewController:accountVC animated:YES];
}
- (void)msgAction
{
    MsgMainVC *msgVC = [[MsgMainVC alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}
- (void)mineInfoAction
{
    MsgMainVC *msgVC = [[MsgMainVC alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}
- (void)messageAction:(UIButton *)btn
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PesonalCell *cell = [tableView dequeueReusableCellWithIdentifier:PSCellID forIndexPath:indexPath];
    [cell handleCellData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *skipVCName = dic[@"skipController"];
//    if (indexPath.row == 0) {
//        SDQViewController *vc = [[SDQViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 1){
//        SDQFeeDetialViewController *vc = [[SDQFeeDetialViewController alloc] init];
//        vc.userType = SDQFeeDetialWuye;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
        Class skipVC = NSClassFromString(skipVCName);
        UIViewController *vc = [[skipVC alloc] init];
        if ([vc isKindOfClass:[SDQFeeDetialViewController class]]) {
            SDQFeeDetialViewController *wuye = (SDQFeeDetialViewController *)vc;
            wuye.userType = SDQFeeDetialWuye;
        }
        if ([vc isKindOfClass:NSClassFromString(@"RenterMangeVC")] && [[UserInfo sharedUserInfo].status isEqualToString:@"租客"]) {
            [SVProgressHUD showErrorWithStatus:@"对不起！您没有管理住户权限"];
            return;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - 接口请求
- (void)requestUserInfo{
    [RequestApi getUserInfoWithUserId:[UserInfo sharedUserInfo].userId
                              success:^(NSDictionary *successData) {
                                  if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                      [SVProgressHUD dismiss];
                                      //请求成功处理
                                      NSDictionary *retData = successData[@"data"];
                                      if (retData.count > 0) {
                                          [[UserInfo sharedUserInfo] setupDataWithDic:retData];
                                          
                                          [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
                                          self.nameLabel.text = [UserInfo sharedUserInfo].userName;
                                          self.identifyLabel.text = [UserInfo sharedUserInfo].status;
                                          self.phoneLabel.text = [UserInfo sharedUserInfo].phoneNumber.length == 11 ?
                                          [[UserInfo sharedUserInfo].phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] :
                                          [UserInfo sharedUserInfo].phoneNumber;
                                      }else{
                                          [SVProgressHUD showErrorWithStatus:@"获取信息异常，请稍后重试"];
                                      }
                                  }else{
                                      [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                  }
                              }
                               failed:^(NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"稍后重试"];
                               }];
}

@end
