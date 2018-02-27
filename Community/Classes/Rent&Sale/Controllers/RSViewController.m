//
//  RSViewController.m
//  Community
//
//  Created by liuchun on 16/6/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RSViewController.h"
#import "HomeCell.h"
#import "RentingHouseViewController.h"
#import "AskRentSaleVC.h"
#import "BNRSDetailVC.h"
#import "RentInfoModel.h"
#import "MJRefresh.h"
#import "cc_macro.h"
#import "HouseRentSaleCell.h"
@interface RSViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *noRecordView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger lastCount;

@end

@implementation RSViewController
static NSString *const RSCellID = @"RSCellID";

//每页显示的条数
static NSString *const pageSize = @"10";


- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.page = 0; self.lastCount = 0;
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
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
//    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, 35*BILI_WIDTH)];
//    topBar.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:topBar];
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.h - 1, SCREEN_WIDTH, 1)];
//    line.backgroundColor = UIColor_GrayLine;
//    [topBar addSubview:line];
//    
//    CGFloat btnWidth = SCREEN_WIDTH / 3.0;
//    NSArray *titles = @[@"车位租售", @"住房租售", @"求租求购"];
//    for (int i = 0; i < 3; i ++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(btnWidth * i,0 , btnWidth, topBar.h - 1);
//        btn.tag = i + 1;
//        [btn setTitle:titles[i] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [btn setTitleColor:UIColor_Gray_Text forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.selected = i == 0;
//        [topBar addSubview:btn];
//    }
    
////    NSAttributedString *atts = [[NSAttributedString alloc] initWithString:titles[0] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 * BILI_WIDTH]}];
//    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.h - 1,btnWidth, 2)];
//    blueLine.backgroundColor = UIColorFromRGB(0x2288f2);
//    [topBar addSubview:blueLine];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight - NaviHeight - 35*BILI_WIDTH)];
    tableView.rowHeight = 94 * BILI_WIDTH;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    #import "HouseRentSaleCell.h"
    [tableView registerClass:[HouseRentSaleCell class] forCellReuseIdentifier:RSCellID];
    _tableView = tableView;
    
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableView.h)];
    noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    noRecordView.hidden = YES;
    [self.view addSubview:noRecordView];
    _noRecordView = noRecordView;
    
    UIImageView *noRecordImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 192 * NEW_BILI, 151 * NEW_BILI)];
    noRecordImg.center = CGPointMake(self.view.centerX, self.view.centerY - NaviHeight - 35*BILI_WIDTH);
    noRecordImg.image = [UIImage imageNamed:@"no_data"];
    [noRecordView addSubview:noRecordImg];
    
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseRentSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:RSCellID forIndexPath:indexPath];
    [cell handleCellWithInfo:self.datas[indexPath.row]];
    return  cell;
}


#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BNRSDetailVC *infoVC =  [[BNRSDetailVC alloc] init];
    infoVC.model = self.datas[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TableViewScroll object:nil];
}
- (void)articalList
{
    [RequestApi getInfoListWithArticleType:nil
                                 titleType:@"2"
                                    userId:nil
                                     index:[NSString stringWithFormat:@"%ld",(long)self.page]
                                      size:pageSize
                                   success:^(NSDictionary *successData) {
                                       NSLog(@"车位列表---->>>>> %@",successData);
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

@end
