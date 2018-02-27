//
//  RenterMangeVC.m
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RenterMangeVC.h"
#import "ManagerCell.h"
#import "RenterInfoViewController.h"
#import "AddRenterVC.h"
#import "cc_macro.h"
@interface RenterMangeVC ()<UITableViewDataSource, UITableViewDelegate, ManagerCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, weak) UIView *noRecordView;

@end

@implementation RenterMangeVC

static NSString *const managerCell = @"managerCell";

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"住户管理";
    [self setupLoadedView];
    
    [self requestRenterList];
}


- (void)setupLoadedView
{
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 70, 44);
    [addBtn setTitle:@"添加住户" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addBtn addTarget:self action:@selector(addBtnAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:addBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.rowHeight = 103 * BILI_WIDTH;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[ManagerCell class] forCellReuseIdentifier:managerCell];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _noRecordView.hidden = self.datas.count != 0;
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:managerCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setupCellWithDic:self.datas[indexPath.row] index:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RenterInfoViewController *infoVC = [[RenterInfoViewController alloc] init];
    infoVC.dic = [self.datas objectAtIndex:indexPath.row];
    [self pushViewController:infoVC animated:YES];
}

- (void)requestRenterList
{
    [RequestApi searchLesseesWithUserId:[UserInfo sharedUserInfo].userId success:^(NSDictionary *successData) {

        NSLog(@"住户列表----->>>>>>%@",successData);
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSArray *returnData = [successData valueNotNullForKey:kRequestReturnData];
          
            [self.datas addObjectsFromArray:returnData];
            [self.tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
        }

        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}


#pragma  mark -ManagerCellDelegate
- (void)callBtnAcion:(UIButton *)button
{
    NSDictionary *dic = [self.datas objectAtIndex:button.tag];
    NSString *phoneNum = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"mobile"]];
    
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

}

//添加租户
- (void)addBtnAciton
{
    AddRenterVC *addVC = [[AddRenterVC alloc] init];
    [self pushViewController:addVC animated:YES];
}

- (void)addRenterSuccessAndRefreshInfo
{
    [self requestRenterList];
}


@end
