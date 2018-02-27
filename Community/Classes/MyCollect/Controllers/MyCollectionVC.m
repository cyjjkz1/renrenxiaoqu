//
//  MyCollectionVC.m
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MyCollectionVC.h"
#import "MyCollectTableViewCell.h"
#import "BNRSDetailVC.h"
#import "MJRefresh.h"
#import "cc_macro.h"
@interface MyCollectionVC ()<UITableViewDelegate, UITableViewDataSource, MyCollectTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, assign) int page;
@property (nonatomic, weak) UIButton *selectAll;

@property (nonatomic, weak) UIView *noRecordView;

@end

@implementation MyCollectionVC

static NSString *const collectCellId = @"CollectCellId";

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"收藏";
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.page = 1;
    [self getCollectionData:self.page];
}

- (void)setupLoadedView
{
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 40, 44);
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [selectAllBtn.titleLabel setFont:[UIFont systemFontOfSize:14*BILI_WIDTH]];
    [selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:selectAllBtn];
    _selectAll = selectAllBtn;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.rowHeight = 64 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    _tableView = tableView;
    
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    
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

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self cheackSelectAllBtnCanUse];
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectCellId];
    if (!cell) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"删除" forState:UIControlStateNormal];
        [button1 setBackgroundColor:[UIColor redColor]];
        
        NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithObjects:button1, nil];
        cell = [[MyCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:collectCellId
                                  containingTableView:_tableView
                                          leftButtons:nil
                                         rightButtons:buttonArray];
        cell.delegate = self;
    }
    cell.infoModel = self.datas[indexPath.row];
    cell.allSelected = self.isAllSelect;
    return cell;
}


#pragma mark - UITableViewDelegate
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
    BNRSDetailVC *infoVC = [[BNRSDetailVC alloc] init];
    infoVC.model = self.datas[indexPath.row];
    [self pushViewController:infoVC animated:YES];
}


- (void)swippableTableViewCell:(MyCollectTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSInteger index = [self.tableView indexPathForCell:cell].row;
            
            //删除数据源
            RentInfoModel *infoModel = [self.datas objectAtIndex:index];
            
            [self.datas removeObject:infoModel];
            
            //删除数据库
            [LCDataTool removeCollect:infoModel];
            
            //刷新表
            [_tableView reloadData];
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            
            break;
        }
    }
}


- (void)getCollectionData:(int)page
{
    if (page == 1) {
        [self.datas removeAllObjects];
    }
    
        [self.datas addObjectsFromArray:[LCDataTool collectInfo:page]];
   
    [_tableView reloadData];
    [self checkFooterStatus];
}

//上拉加载更多
- (void)loadMore
{
    self.page ++;
    [self getCollectionData:self.page];
}

//检查底部刷新控件状态
- (void)checkFooterStatus
{
    _tableView.footer.hidden = (self.datas.count == 0);
    
    NSInteger count = [LCDataTool collectInfosCount];
    NSLog(@"数据库中的个数  %ld", (long)count);
    
    // 让底部控件结束刷新
    if (self.datas.count == count) { // 全部数据已经加载完毕
        [_tableView.footer noticeNoMoreData];
    } else { // 还没有加载完毕
        [_tableView.footer endRefreshing];
    }

}

- (void)selectAllAciton:(UIButton *)button
{
    if (self.isAllSelect == YES)return;
    self.isAllSelect = YES;
    [_tableView reloadData];
    [self setupDeleteButton];
}


- (void)setupDeleteButton
{
    UIButton *cancelAll = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelAll.frame = CGRectMake(15*BILI_WIDTH, SCREEN_HEIGHT - 45*BILI_WIDTH, 143*BILI_WIDTH, 35*BILI_WIDTH);
    [cancelAll setuporangeBtnTitle:@"取消全选" enable:YES];
    cancelAll.tag = 101;
    [cancelAll addTarget:self action:@selector(downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelAll];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(cancelAll.maxX + 8*BILI_WIDTH, cancelAll.y, cancelAll.w, cancelAll.h);
    [delete setuporangeBtnTitle:@"删 除" enable:YES];
    delete.tag = 102;
    [delete addTarget:self action:@selector(downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
}


- (void)downButtonAction:(UIButton *)button
{
    if (button.tag == 101) {//取消全选
        self.isAllSelect = NO;
        [_tableView reloadData];
        
        [self removeBottomTwoButton];
        
    }else{//删除全部
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除全部收藏" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
}


#pragma mark - UIAlertViewDelegate
//删除全部逻辑
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }
    //删除数据库
    for (int i = 0; i < self.datas.count; i ++) {
        RentInfoModel *infoModel = [self.datas objectAtIndex:i];
        [LCDataTool removeCollect:infoModel];
    }
    //删除数据源
    [self.datas removeAllObjects];
    [_tableView reloadData];
    
    //移除按钮
    [self removeBottomTwoButton];
    
    //提示删除成功
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
}


//检查全选按钮是否显示
- (void)cheackSelectAllBtnCanUse
{
    if ([LCDataTool collectInfosCount] <= 0) {
        _selectAll.hidden = YES;
        [self removeBottomTwoButton];
    }else{
        _selectAll.hidden = NO;
    }
    _noRecordView.hidden = self.datas.count != 0;
}

//移除下面两个button
- (void)removeBottomTwoButton
{
    UIButton *cancelBtn = [self.view viewWithTag:101];
    UIButton *deleteBtn = [self.view viewWithTag:102];
    //移除按钮
    [cancelBtn removeFromSuperview];
    [deleteBtn removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
