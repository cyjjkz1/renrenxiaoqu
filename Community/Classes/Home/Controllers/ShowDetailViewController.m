//
//  ShowDetailViewController.m
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "ShowDetailCell.h"
#import "cc_macro.h"
@interface ShowDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowDetailViewController

static NSString *const ShowDetailCellID = @"ShowDetailCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"明细";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.rowHeight = 75;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[ShowDetailCell class] forCellReuseIdentifier:ShowDetailCellID];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowDetailCellID forIndexPath:indexPath];
    return cell;
}


@end
