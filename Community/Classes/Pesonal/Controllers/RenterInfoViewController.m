//
//  RenterInfoViewController.m
//  Community
//
//  Created by mac1 on 16/7/4.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RenterInfoViewController.h"
#import "MoreFunctionDropView.h"
#import "RenterInfoFirstCell.h"
#import "RenterInfoSecondCell.h"


@interface RenterInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) MoreFunctionDropView *dropView;

@end

@implementation RenterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"住户详情";
    
    //租户详情
    [self setupLoadedView];
}


- (void)setupLoadedView
{
    [super setupLoadedView];
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    self.baseScrollView.delegate = self;
    
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    [rightBar setImage:[UIImage imageNamed:@"more_btn"] forState:UIControlStateNormal];
    [rightBar addTarget:self action:@selector(moreAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightBar];
    
    UIView *headBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63*BILI_WIDTH)];
    headBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:headBGView];
    
    //头像
    NSString *avatarUrl = @"";
    NSDictionary *photos = [_dic valueNotNullForKey:@"photo"];
    if ([photos isKindOfClass:[NSDictionary class]]) {
        avatarUrl = [photos valueNotNullForKey:@"visitUrl"];
    }else if ([photos isKindOfClass:[NSString class]]){
        avatarUrl = avatarUrl;
    }
    
    CGFloat avatarH = 45*BILI_WIDTH;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(18*BILI_WIDTH, (63*BILI_WIDTH - avatarH) * 0.5, avatarH, avatarH)];
    [avatar sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [headBGView addSubview:avatar];
    
    //姓名
    NSString *theName = [NSString stringWithFormat:@"%@%@",[_dic valueNotNullForKey:@"firstName"],[_dic valueNotNullForKey:@"lastName"]];
    if ([theName isEqualToString:@"nullnull"]) {
        theName = @"住户暂未设置";
    }
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(avatar.maxX + 15*BILI_WIDTH, 18 * BILI_WIDTH, 200, 13*BILI_WIDTH)];
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    NSString *nameStr = [NSString stringWithFormat:@"姓名：%@",theName];
    NSMutableAttributedString *nameMatts = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [nameMatts setAttributes:@{NSForegroundColorAttributeName : UIColor_Gray_Text} range:NSMakeRange(3, nameStr.length - 3)];
    name.attributedText = nameMatts;
    [headBGView addSubview:name];
    
    //电话号码
    NSString *thePhone = [NSString stringWithFormat:@"%@",[_dic valueNotNullForKey:@"mobile"]];
    NSString *phoneStr = [NSString stringWithFormat:@"电话：%@",thePhone];
    NSMutableAttributedString *phoneMatts = [[NSMutableAttributedString alloc] initWithString:phoneStr];
    [phoneMatts setAttributes:@{NSForegroundColorAttributeName : UIColor_Gray_Text} range:NSMakeRange(3, phoneStr.length - 3)];
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(name.x, name.maxY + 8 * BILI_WIDTH , 200, 12*BILI_WIDTH)];
    phoneNum.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    phoneNum.attributedText = phoneMatts;
    [headBGView addSubview:phoneNum];
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, headBGView.maxY + 10, SCREEN_WIDTH, 100)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBGView];
    
    NSAttributedString *temAtts = [[NSAttributedString alloc] initWithString:@"创建时间：" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12*BILI_WIDTH]}];
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, temAtts.size.width, 20)];
//    address.backgroundColor = [UIColor redColor];
    address.text = @"住户地址：";
    address.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    address.textAlignment = NSTextAlignmentRight;
    [whiteBGView addSubview:address];
    [address sizeToFit];
    
    NSString *adsStr = [_dic valueNotNullForKey:@"address"];
    if ([adsStr isEqualToString:@"null"]) {
        adsStr = @"用户暂未设置";
    }
//    adsStr = @"用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置用户暂未设置";
    CGFloat adsW = SCREEN_WIDTH - address.maxX - 10;
    CGFloat adsStrH = [Tools caleHeightWithTitle:adsStr font:[UIFont systemFontOfSize:12 * BILI_WIDTH] width:adsW];
    UILabel *adsRightLbl = [[UILabel alloc] initWithFrame:CGRectMake(address.maxX + 5, address.y, adsW, adsStrH)];
    adsRightLbl.text = adsStr;
    adsRightLbl.numberOfLines = 0;
    adsRightLbl.textColor = UIColor_Gray_Text;
    adsRightLbl.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:adsRightLbl];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(address.x, adsRightLbl.maxY + 8, 40, temAtts.size.width)];
//    date.backgroundColor = [UIColor redColor];
    date.text = @"创建时间：";
    date.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    date.textAlignment = NSTextAlignmentRight;
    [whiteBGView addSubview:date];
    [date sizeToFit];
    
    UILabel *dateRightLbl = [[UILabel alloc] initWithFrame:CGRectMake(date.maxX + 5, date.y, SCREEN_WIDTH - date.maxY - 10, 18)];
    dateRightLbl.text = [self changeStempWithDateString:[[_dic valueNotNullForKey:@"createtime"] integerValue]];
    dateRightLbl.numberOfLines = 0;
    dateRightLbl.textColor = UIColor_Gray_Text;
    dateRightLbl.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    [whiteBGView addSubview:dateRightLbl];
    whiteBGView.h = dateRightLbl.maxY + 8;
    
    
//    address = "<null>";
//    buildingName = "<null>";
//    createtime = 1477446113000;
//    firstName = "<null>";
//    gender = "<null>";
//    id = 46;
//    lastLoginTime = "<null>";
//    lastName = "<null>";
//    mobile = 13030303030;
//    page = "<null>";
//    parentId = 34;
//    password = 6A32F62101C10A570A9F1B656C373122;
//    photo = "<null>";
//    repassword = "<null>";
//    roomName = "<null>";
//    salt = d1a2e94cc16f4873ba5b4ae7287c03fe;
//    status = 1;
//    type = 2;

    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT)];
//    tableView.backgroundColor = UIColor_Gray_BG;
//    tableView.rowHeight = 103 * BILI_WIDTH;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];

}
/*
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        RenterInfoFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info_first"];
        if (!cell) {
            cell = [[RenterInfoFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info_first"];
        }
        //刷新UI
        
        return cell;
        
    }else{
        RenterInfoSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info_second"];
        if (!cell) {
            cell = [[RenterInfoSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info_second"];
        }
        //刷新UI
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 13 * BILI_WIDTH, 0, 10 * BILI_WIDTH)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 13 * BILI_WIDTH, 0, 10 * BILI_WIDTH)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row == 0) ? 63 * BILI_WIDTH : 43 * BILI_WIDTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 * BILI_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.w, 10 * BILI_WIDTH)];
    header.backgroundColor = UIColor_Gray_BG;
    return  header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

*/

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_dropView) {
        [_dropView removeFromSuperview];
        _dropView = nil;
        return;
    }

}

- (void)moreAcion:(UIButton *)button
{
    if (_dropView) {
        [_dropView removeFromSuperview];
        _dropView = nil;
        return;
    }
    CGRect dropRect = CGRectMake(SCREEN_WIDTH - 87 * BILI_WIDTH - 14, button.maxY + 20, 87 * BILI_WIDTH, 54 * BILI_WIDTH);
    NSArray *titles = @[@"解除关系", @"联系物管"];
    MoreFunctionDropView *dropView = [[MoreFunctionDropView alloc] initWithFrame:dropRect itemTitles:titles];
    typeof(dropView) weakDropView = dropView;
    dropView.clickedBlock = ^(NSInteger index)
    {
        [weakDropView removeFromSuperview];
        _dropView = nil;
        switch (index) {
            case 0:
            {
                NSString *thePhone = [NSString stringWithFormat:@"%@",[_dic valueNotNullForKey:@"mobile"]];
                //解除绑定
                [SVProgressHUD showWithStatus:@"请稍后..."];
                [RequestApi relieveRelationShipByMasterWithUserId:[UserInfo sharedUserInfo].userId
                                                     renterMobile:thePhone
                                                          success:^(NSDictionary *successData) {
                                                              NSLog(@"业主解除绑定--->>>>> %@",successData);
                                                              if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                                  [SVProgressHUD showSuccessWithStatus:@"解除绑定成功"];
                                                                  
                                                              }else{
                                                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                  [SVProgressHUD showErrorWithStatus:retMsg];
                                                              }
                                                              
                                                          } failed:^(NSError *error) {
                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                          }];
            }
                break;
            case 1:
            {
                //联系物管
                UIWebView *webView = [[UIWebView alloc]init];
                NSURL *url = [NSURL URLWithString:@"tel://028-86985158"];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];;
            }
                break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:dropView];
    _dropView = dropView;
}


- (NSString *)changeStempWithDateString:(NSInteger)stemp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stemp/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *str = [formatter stringFromDate:date];
    
    
    return str;

}

@end
