//
//  PersonalViewController.m
//  Community
//
//  Created by liuchun on 16/6/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "PersonalViewController.h"
#import "KeychainItemWrapper.h"
#import "PesonalCell.h"
#import "WEGViewController.h"
#import "AccountInfoViewController.h"
#import "MyPublishMainVC.h"
#import "MsgMainVC.h"
#import "cc_macro.h"

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *datas;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *avatarImageView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneNumLabel;
@property (nonatomic, weak) UILabel *typeLabel;

@end

@implementation PersonalViewController

static NSString *const PSCellID = @"PSCellID";

- (NSArray *)datas
{
    if (!_datas) {
        
        _datas = @[@[@{@"imageName":@"my_weg",@"title":@"我的水电气",@"skipController": @"WEGViewController"},@{@"imageName":@"my_wuye_fees",@"title":@"我的物业费",@"skipController": @"WEGViewController"}], @[@{@"imageName":@"my_fabu",@"title":@"我的发布",@"skipController": @"MyPublishMainVC"},@{@"imageName":@"my_collection",@"title":@"收藏",@"skipController": @"MyCollectionVC"}], @[@{@"imageName":@"manage_renter",@"title":@"住户管理",@"skipController": @"RenterMangeVC"},@{@"imageName":@"my_wuguan",@"title":@"我的物管",@"skipController": @"AboutWuyeVC"}], @[@{@"imageName": @"setting_btn", @"title": @"设置",@"skipController": @"SettingViewController"}]];
    }
    
    return _datas;
}

- (void)dealloc
{
    //[[UserInfo sharedUserInfo] removeObserver:self forKeyPath:@"hasGetProfile"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationTitle = @"个人中心";
    self.backButton.hidden = YES;
    [self setupLoadedView];
    [self getProfileFinishRefreshUserInfo];
    
    
//    [[UserInfo sharedUserInfo] addObserver:self forKeyPath:@"hasGetProfile" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getProfileFinishRefreshUserInfo];
}

- (void)setupLoadedView
{
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    [msgBtn setImage:[UIImage imageNamed:@"my_msg"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:msgBtn];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 82 * BILI_WIDTH)];
    headerView.backgroundColor = UIColor_Gray_BG;
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH, 71 * BILI_WIDTH)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteBGView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAccountInfo)];
    [whiteBGView addGestureRecognizer:tap];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(18 * BILI_WIDTH, 13 * BILI_WIDTH, 45*BILI_WIDTH , 45 * BILI_WIDTH)];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    headImg.layer.cornerRadius = headImg.h * 0.5;
    headImg.layer.masksToBounds = YES;
    
//    NSString *path = [[Tools getDocumentPath] stringByAppendingPathComponent:@"avatar"];
//    NSData *imageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//    if (imageData) {
//        UIImage *image = [UIImage imageWithData:imageData];
//        headImg.image = image;
//    }else{
//        headImg.image = [UIImage imageNamed:@"avatar_default"];
//    }
    [whiteBGView addSubview:headImg];
    _avatarImageView = headImg;
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(headImg.maxX + 8*BILI_WIDTH, 19 * BILI_WIDTH, 200, 13 * BILI_WIDTH)];
    name.textColor = [UIColor blackColor];
    name.text = @"_ _";
    name.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:name];
    _nameLabel = name;
    
    UILabel *phoneNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(name.x, name.maxY + 8 * BILI_WIDTH, 200, 13 * BILI_WIDTH)];
    phoneNumLbl.textColor = UIColor_Gray_Text;
    phoneNumLbl.text = @"***********";
    phoneNumLbl.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:phoneNumLbl];
    _phoneNumLabel = phoneNumLbl;
    
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -  68*BILI_WIDTH, 19 * BILI_WIDTH, 50, 30 * BILI_WIDTH)];
    type.textColor = [UIColor whiteColor];
    type.text = @"_ _";
    type.textAlignment = 1;
    type.backgroundColor = UIColorFromRGB(0xff9600);
    type.layer.cornerRadius = 4 * BILI_WIDTH;
    type.layer.masksToBounds = YES;
    type.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    type.adjustsFontSizeToFitWidth = YES;
    [whiteBGView addSubview:type];
    _typeLabel = type;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - TabbarHeight - NaviHeight)];
    tableView.rowHeight = 40 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    _tableView = tableView;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    [tableView registerClass:[PesonalCell class] forCellReuseIdentifier:PSCellID];
}


#pragma  mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PesonalCell *cell = [tableView dequeueReusableCellWithIdentifier:PSCellID forIndexPath:indexPath];
    NSArray *arr = self.datas[indexPath.section];
    [cell handleCellData: arr[indexPath.row]];
    return cell;
}

#pragma  mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.datas[indexPath.section][indexPath.row];
    NSString *skipVCName = dic[@"skipController"];
    if (indexPath.section == 0) {
        WEGViewController *vc = [[WEGViewController alloc] init];
        vc.useType = indexPath.row ==0 ? WEGVCUseTypeWaterElecGas : WEGVCUseTypePropertyCost;
        [self pushViewController:vc animated:YES];
        return;
    }
    
    if (skipVCName && skipVCName.length > 0) {
        Class skipVC = NSClassFromString(skipVCName);
        UIViewController *vc = [[skipVC alloc] init];
        if ([vc isKindOfClass:NSClassFromString(@"RenterMangeVC")] && [[UserInfo sharedUserInfo].status isEqualToString:@"租客"]) {
            [SVProgressHUD showErrorWithStatus:@"对不起！您没有管理住户权限"];
            return;
        }
        [self pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8 * BILI_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8 * BILI_WIDTH)];
    header.backgroundColor = UIColor_Gray_BG;
    return header;
}

- (void)goAccountInfo
{
    if (![UserInfo sharedUserInfo].hasGetProfile) {
        [SVProgressHUD showErrorWithStatus:@"用户信息刷新中，请稍后再试!"];
        return;
    }
    AccountInfoViewController *accountVC = [[AccountInfoViewController alloc] init];
    [self pushViewController:accountVC animated:YES];
}

- (void)msgAction
{
    MsgMainVC *msgVC = [[MsgMainVC alloc] init];
    [self pushViewController:msgVC animated:YES];
}


/*
- (void)refreshAvatar
{
    if (_avatarImageView) {
        NSString *path = [[Tools getDocumentPath] stringByAppendingPathComponent:@"avatar"];
        NSData *imageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            _avatarImageView.image = image;
        }else{
            _avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
        }
    }
}
*/
// KVO 监听getProfile
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    NSString *isProfile = [NSString stringWithFormat:@"%@",[change valueNotNullForKey:@"new"]];
//    if ([isProfile isEqualToString:@"1"]) {
//        [self getProfileFinishRefreshUserInfo];
//    }
//}


- (void)getProfileFinishRefreshUserInfo
{
   
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
    NSString *userId = [keychain objectForKey:(id)kSecValueData];
    
    //保存到单例类
    UserInfo *user = [UserInfo sharedUserInfo];
    user.userId = userId;
    
    // 根据userid获取profile
//    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi getUserInfoWithUserId:userId success:^(NSDictionary *successData) {
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *data = [successData valueNotNullForKey:kRequestReturnData];
            
            [user setupDataWithDic:data];
            if (![user.userName isEqualToString:@"--"]) {
                _nameLabel.text = user.userName;
            }
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
            _phoneNumLabel.text = [user.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _typeLabel.text = user.status;
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

@end
