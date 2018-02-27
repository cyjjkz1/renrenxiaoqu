//
//  MsgMainVC.m
//  Community
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MsgMainVC.h"
#import "MassageCell.h"
#import "MJRefresh.h"
#import "cc_macro.h"
@interface MsgMainVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *noRecordView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int totalCount;
@end

@implementation MsgMainVC

static NSString *const firstMsgCellID = @"firstMsgCellID";
NSString *const pageCount = @"10";  //每页显示的条数

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.navigationTitle = @"我的通知";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.rowHeight = 70 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    _tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    [tableView registerClass:[MassageCell class] forCellReuseIdentifier:firstMsgCellID];

    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    
    //进来就下拉刷新
    [tableView.header beginRefreshing];
    [self setupNoRecord];
}


- (void)setupNoRecord
{
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    noRecordView.hidden = YES;
    [self.view addSubview:noRecordView];
    _noRecordView = noRecordView;
    
    UIImageView *noRecordImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 192 * NEW_BILI, 151 * NEW_BILI)];
    noRecordImg.center = CGPointMake(self.view.centerX, self.view.centerY - NaviHeight - 35*BILI_WIDTH);
    noRecordImg.image = [UIImage imageNamed:@"no_data"];
    [noRecordView addSubview:noRecordImg];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _noRecordView.hidden = self.datas.count != 0;
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MassageCell *cell = [tableView dequeueReusableCellWithIdentifier:firstMsgCellID forIndexPath:indexPath];
    [cell setupCellWithDictonary:self.datas[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)loadMsg
{
    NSString *userId = [UserInfo sharedUserInfo].userId;
    if (!userId) {
        return;
    }
    [RequestApi requestUserMsgWithUserId:userId
                                   index:[NSString stringWithFormat:@"%d",self.page]
                                 andSize:pageCount
                                 success:^(NSDictionary *successData) {
                                     NSLog(@"获取用户消息--->>>>%@",successData);
                                     if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                         NSArray *datas = successData[kRequestReturnData];
                                         if (self.page == 1) {
                                             [self.datas removeAllObjects];
                                             [self.tableView.header endRefreshing];
                                         }
                                         [self.datas addObjectsFromArray:datas];
                                         [self.tableView reloadData];
                                     }else{
                                         NSString *retMsg = successData[kRequestRetMessage];
                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                     }
                                 } failed:^(NSError *error) {
                                     
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                     
                                 }];
    [self checkFooterStatus];
}

//下拉刷新
- (void)loadNew
{
    self.page = 1;
    [self loadMsg];
}

//上拉加载
- (void)loadMore
{
    self.page ++;
    [self loadMsg];
}

//检查底部刷新控件状态
- (void)checkFooterStatus
{
    _tableView.footer.hidden = (self.datas.count == 0);
    
    // 让底部控件结束刷新
    if (self.datas.count == self.totalCount) { // 全部数据已经加载完毕
        [_tableView.footer noticeNoMoreData];
    } else { // 还没有加载完毕
        [_tableView.footer endRefreshing];
    }
    
}


@end
