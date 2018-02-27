//
//  RentingHouseViewController.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RentingHouseViewController.h"
#import "RentHouseTopItem.h"
#import "SelectVillageViewController.h"
#import "SelectRentFeesViewController.h"
#import "SelectHouseVC.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "BNRSDetailVC.h"
#import "cc_macro.h"
#import "HouseRentSaleCell.h"
@interface RentingHouseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIViewController *showingVc;
@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSArray *dropItem1;
@property (nonatomic, strong) NSArray *dropItem2;
@property (nonatomic, strong) NSArray *dropItem3;


@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *noRecordView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) NSInteger page;

@end

@implementation RentingHouseViewController

static NSString *const RHCellID = @"RHCellID";
static NSString *const pageSize = @"10";

- (NSMutableArray *)items
{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}


- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastCount = 0; self.page = 0;
    [self setupLoadedView];
    [self.tableView.header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentData) name:kNotification_UpdateCurrentPageData object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_UpdateCurrentPageData object:nil];
}
- (void)updateCurrentData
{
    [self loadNew];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.datas.count == 0) {
        [self loadNew];
    }
}

- (void)setupLoadedView
{
    /*
    [kNotificationCenter addObserver:self selector:@selector(villageChanged:) name:kNotification_SelectedVillage object:nil];
    [kNotificationCenter addObserver:self selector:@selector(rentFeesChanged:) name:kNotification_SelectedRentFees object:nil];
    [kNotificationCenter addObserver:self selector:@selector(houseChanged:) name:kNotification_SelectedHouse object:nil];
    
    SelectVillageViewController *villageVC = [[SelectVillageViewController alloc] init];
    villageVC.datas = @[@"香榭国际", @"御廷上郡", @"楠香山"];
    [self addChildViewController:villageVC];
    
    SelectRentFeesViewController *feesVC = [[SelectRentFeesViewController alloc] init];
    feesVC.datas = @[@"不限", @"500以下", @"500~1000元", @"1000~1500元", @"1500~2000元"];
    [self addChildViewController:feesVC];
    
    SelectHouseVC *houseVC = [[SelectHouseVC alloc] init];
    houseVC.datas = @[@"不限", @"1室", @"2室", @"3室", @"4室", @"4室以上"];
    [self addChildViewController:houseVC];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39 * BILI_WIDTH)];
    [self.view addSubview:topView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topView.h - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [topView addSubview:line];
    
    
    CGFloat itemWidth = SCREEN_WIDTH / 3.0;
    NSArray *titles = @[@"本小区", @"租金", @"厅室"];
    for (int i = 0; i < 3; i ++) {
        RentHouseTopItem *item = [[RentHouseTopItem alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, topView.h)];
        item.title = titles[i];
        item.tag = i + 1;
        item.selected = i == 0;
        typeof(item) weakItem = item;
        item.clickedBlock = ^(NSInteger index){
            for (RentHouseTopItem *theItem in self.items) {
                theItem.selected = NO;
            }
            weakItem.selected = YES;
            
            if (!_coverView) {
                UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - topView.maxY)];
                coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShowingVC)];
                [coverView addGestureRecognizer:tap];
                [self.view addSubview:coverView];
                _coverView = coverView;
            }
            
          
            UIViewController *showVC = [self.childViewControllers objectAtIndex:index - 1];
            if (_showingVc == showVC) {
                [self dismissShowingVC];
                return ;
            }
            if (_showingVc.view) {
                [_showingVc.view removeFromSuperview];
            }
            //kvc获取datas
            NSArray *datas = [showVC valueForKey:@"datas"];
            CGFloat tableHeight = datas.count > 5 ? 200 : 40 * datas.count;
            
            showVC.view.layer.anchorPoint = CGPointMake(0.5, 0);
            showVC.view.layer.frame = CGRectMake(weakItem.x, topView.maxY, itemWidth, tableHeight);
            showVC.view.backgroundColor = [UIColor redColor];
            showVC.view.userInteractionEnabled = YES;
            [self.view addSubview:showVC.view];
 
            showVC.view.transform = CGAffineTransformMakeScale(1.0, 0.0000001);
   
            [UIView animateWithDuration:0.3 animations:^{
                showVC.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
            _showingVc = showVC; //记录当前是哪个vc在被显示，以便下次点击移除
        };
        
        
        [self.items addObject:item];
        [topView addSubview:item];
    }
     
     */
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 35 * BILI_WIDTH - TabbarHeight - NaviHeight)];
    tableView.rowHeight = 90 * BILI_WIDTH;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[HouseRentSaleCell class] forCellReuseIdentifier:RHCellID];
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView = tableView;
    
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableView.h)];
    noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    noRecordView.hidden = YES;
    [self.view addSubview:noRecordView];
    _noRecordView = noRecordView;
    
    UIImageView *noRecordImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 192 * NEW_BILI, 151 * NEW_BILI)];
    noRecordImg.center = CGPointMake(self.view.centerX, self.view.centerY - NAVIGATION_STATUSBAR_HEIGHT - 35*BILI_WIDTH);
    noRecordImg.image = [UIImage imageNamed:@"no_data"];
    [noRecordView addSubview:noRecordImg];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TableViewScroll object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _noRecordView.hidden = self.datas.count != 0;
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseRentSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:RHCellID forIndexPath:indexPath];
    [cell handleCellWithInfo:self.datas[indexPath.row]];
    return  cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BNRSDetailVC *infoVC =  [[BNRSDetailVC alloc] init];
    infoVC.model = self.datas[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
    
                    
}

- (void)articalList
{
    [RequestApi getInfoListWithArticleType:nil
                                 titleType:@"1"
                                    userId:nil
                                     index:[NSString stringWithFormat:@"%ld",(long)self.page]
                                      size:pageSize
                                   success:^(NSDictionary *successData) {
                                       NSLog(@"住房列表---->>>>> %@",successData);
                                       if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                           NSArray *returnData = [successData valueNotNullForKey:kRequestReturnData];
                                           if(self.page == 0){
                                               [self.datas removeAllObjects];
                                           }
                                           for (NSDictionary *dic in returnData) {
                                               RentInfoModel *model = [RentInfoModel modelWithDictionary:dic];
                                               [self.datas addObject:model];
                                               [self.tableView reloadData];
                                           }
                                           [self.tableView.header endRefreshing];
//                                           if (self.page != 0) {
                                               [self checkFooterCanRefresh];
//                                           }
                                           
                                       }else{
                                           [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                       }
                                       
                                   } failed:^(NSError *error) {
                                       
                                       NSLog(@"%@",error);
                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                       
                                   }];
}
- (void)loadNew
{
    self.page = 0;
    [self articalList];
}

- (void)loadMore
{
    self.page ++;
    [self articalList];
}

- (void)checkFooterCanRefresh
{
    _tableView.footer.hidden = (self.datas.count == 0);
    if (self.datas.count == self.lastCount) {
        [self.tableView.footer noticeNoMoreData];
    }else{
        [self.tableView.footer endRefreshing];
        self.lastCount = self.datas.count;
    }
}


/*
//小区发生改变
- (void)villageChanged:(NSNotification *)noti
{
    [self dismissShowingVC];
    NSDictionary *userInfo = noti.userInfo;
    NSString *villageName = userInfo[@"title"];
    RentHouseTopItem *villageItem = self.items[0];
    villageItem.title = villageName;
}

// 租金发生改变
- (void)rentFeesChanged:(NSNotification *)noti
{
    [self dismissShowingVC];
    NSDictionary *userInfo = noti.userInfo;
    NSString *fees = userInfo[@"title"];
    RentHouseTopItem *villageItem = self.items[1];
    if ([fees isEqualToString:@"不限"]) {
        villageItem.title = @"租金不限";
        return;
    }

    villageItem.title = fees;
    
}

// 厅室发生改变
- (void)houseChanged:(NSNotification *)noti
{
    [self dismissShowingVC];
    NSDictionary *userInfo = noti.userInfo;
    NSString *houseName = userInfo[@"title"];
    RentHouseTopItem *villageItem = self.items[2];
    if ([houseName isEqualToString:@"不限"]) {
        villageItem.title = @"厅室不限";
        return;
    }
    villageItem.title = houseName;
   
}

- (void)dismissShowingVC
{
    if (_showingVc.view) {
        [UIView animateWithDuration:.3 animations:^{
            _showingVc.view.transform = CGAffineTransformMakeScale(1.0, 0.0000001);
        } completion:^(BOOL finished) {
            [_showingVc.view removeFromSuperview];
            _showingVc.view = nil;
            _showingVc = nil;
            [_coverView removeFromSuperview];
            _coverView = nil;
        }];
    }
  
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/

@end
