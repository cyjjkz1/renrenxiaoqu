//
//  SelectRentFeesViewController.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "SelectRentFeesViewController.h"
#import "DropViewCell.h"

@interface SelectRentFeesViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SelectRentFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat tableHeight = self.datas.count > 5 ? 200 : 40 * self.datas.count;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3.0, tableHeight)];
    tableView.rowHeight = 40;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[DropViewCell class] forCellReuseIdentifier:@"feesCell"];
    
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
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feesCell" forIndexPath:indexPath];
    cell.title = self.datas[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DropViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *vi in cell.contentView.subviews) {
        if ([vi isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)vi;
            [kNotificationCenter postNotificationName:kNotification_SelectedRentFees object:self userInfo:@{@"title":label.text}];
        }
    }
}


@end
