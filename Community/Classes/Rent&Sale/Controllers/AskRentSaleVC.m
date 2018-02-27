//
//  AskRentSaleVC.m
//  Community
//
//  Created by liuchun on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AskRentSaleVC.h"
#import "HomeCell.h"
#import "BNRSDetailVC.h"
#import "MJRefresh.h"
#import "cc_macro.h"
#import "HouseRentSaleCell.h"
@interface AskRentSaleVC()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *noRecordView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) NSInteger page;

@end

@implementation AskRentSaleVC

NSString *const AskRentSaleCellID = @"AskRentSaleCellID";
static NSString *const pageSize = @"10";

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    self.lastCount = 0; self.page = 0;
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


- (void)setupSubViews
{
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 35 * BILI_WIDTH - TabbarHeight - NaviHeight)];
    tableView.rowHeight = 94 * BILI_WIDTH;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView = tableView;
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//#import "HouseRentSaleCell.h"
    [tableView registerClass:[HouseRentSaleCell class] forCellReuseIdentifier:AskRentSaleCellID];
    
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _noRecordView.hidden = self.datas.count != 0;
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseRentSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:AskRentSaleCellID forIndexPath:indexPath];
    [cell handleCellWithInfo:self.datas[indexPath.row]];
    return  cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TableViewScroll object:nil];
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

- (void)articalList
{
    [RequestApi getInfoListWithArticleType:nil
                                 titleType:@"3"
                                    userId:nil
                                     index:[NSString stringWithFormat:@"%ld",(long)self.page]
                                      size:pageSize
                                   success:^(NSDictionary *successData) {
                                       NSLog(@"求租求购---->>>>> %@",successData);
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
