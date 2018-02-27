//
//  MyPublishMainVC.m
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "MyPublishMainVC.h"
#import "MyPublishCell.h"
#import "RentInfoModel.h"
#import "BNRSDetailVC.h"
#import "cc_macro.h"
@interface MyPublishMainVC ()<UITableViewDelegate, UITableViewDataSource, MyPublishCellDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) UIView *noRecordView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger deleteTag;

@end

@implementation MyPublishMainVC

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (instancetype)init
{
    if (self = [super init]) {
//        [self setupChildViewController];
    }
    return self;
}

//- (void)setupChildViewController
//{
//    self.segmentTextArray = @[@"全部", @"出租房", @"二手房", @"求租房", @"求购房"];
//    
//    MyPubAllVC *page1 = [[MyPubAllVC alloc] init];
//    MyPubRentVC *page2 = [[MyPubRentVC alloc] init];
//    MyPubSecondHandVC *page3 = [[MyPubSecondHandVC alloc] init];
//    MyPubAskRentVC *page4 = [[MyPubAskRentVC alloc] init];
//    MyPubAskSaleVC *page5 = [[MyPubAskSaleVC alloc] init];
//    [self setPages:@[page1, page2, page3, page4, page5].mutableCopy];
//    
//}

static NSString *const PubAllCell = @"PubAllCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.publishBtn.hidden = NO;
    self.navigationTitle = @"我发布的";
    
    [self addSubViews];
    [self getAllPublishInfo];
}


- (void)addSubViews
{
    _deleteTag = 0;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.rowHeight = 100 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    _tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[MyPublishCell class] forCellReuseIdentifier:PubAllCell];

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
    MyPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:PubAllCell forIndexPath:indexPath];
    [cell setupCellWithDictionary:[self.datas objectAtIndex:indexPath.row] index:indexPath];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BNRSDetailVC *detailVC = [[BNRSDetailVC alloc] init];
    detailVC.model = self.datas[indexPath.row];
    [self pushViewController:detailVC animated:YES];
}

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


#pragma mark - Request
- (void)getAllPublishInfo
{
    [RequestApi getInfoListWithArticleType:nil
                                 titleType:nil
                                    userId:[UserInfo sharedUserInfo].userId
                                     index:nil
                                      size:nil
                                   success:^(NSDictionary *successData) {
                                       NSLog(@"我发布的---->>>>> %@",successData);
                                       if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                           NSArray *returnData = [successData valueNotNullForKey:kRequestReturnData];
                                           
                                           for (NSDictionary *dic in returnData) {
                                               RentInfoModel *model = [RentInfoModel modelWithDictionary:dic];
                                               [self.datas addObject:model];
                                           }
//                                           [self.datas addObjectsFromArray:returnData];
                                           [self.tableView reloadData];
                                           
                                       }else{
                                           [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                       }
                                       
                                   } failed:^(NSError *error) {
                                       
                                       NSLog(@"%@",error);
                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                       
                                   }];

}

#pragma mark - MyPublishCellDelegate
- (void)publishBtnAction:(UIButton *)button
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    RentInfoModel *model = self.datas[button.tag];
    NSString *artId = [NSString stringWithFormat:@"%@",model.id];
    NSString *status = [NSString stringWithFormat:@"%@",model.status];
    if ([status isEqualToString:@"2"]) {
        status = @"1";
    }else{
        status = @"2";
    }
    [RequestApi modifyInfoSatatusWithId:artId
                                 status:status
                                success:^(NSDictionary *successData) {
                                    NSLog(@"修改发布状态---->>>>> %@",successData);
                                    if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                        button.selected = !button.selected;
                                        
                                    }else{
                                        [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                    }

                                }
                                 failed:^(NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];
}

- (void)deleteBtnAction:(UIButton *)button
{
    _deleteTag = button.tag - 999;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除此条信息？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    RentInfoModel *model = self.datas[_deleteTag];
    NSString *artId = [NSString stringWithFormat:@"%@",model.id];
//    NSString *status = [NSString stringWithFormat:@"%@",model.status];
  
    [RequestApi modifyInfoSatatusWithId:artId
                                 status:@"0"
                                success:^(NSDictionary *successData) {
                                    NSLog(@"删除发布---->>>>> %@",successData);
                                    if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                        [SVProgressHUD dismiss];
                                        [self.datas removeObjectAtIndex:_deleteTag];
                                        [self.tableView reloadData];
                                        
                                    }else{
                                        [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                    }
                                    
                                }
                                 failed:^(NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];

}

@end
