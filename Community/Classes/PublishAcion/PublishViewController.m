//
//  PublishViewController.m
//  Community
//
//  Created by mac1 on 16/7/6.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "PublishViewController.h"
#import "BNPublishNextVC.h"
#import "PublishType.h"
#import "HouseTypeModel.h"
#import "cc_macro.h"
@interface PublishViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation PublishViewController

- (NSArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
//  @[@"房屋出租", @"房屋出售", @"车位出租", @"车位出售", @"房屋求租", @"房屋求购", @"车位求租", @"车位求购"];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"发布信息";
    [self setupLoadedView];
    
    [self requestPublishType];
}

- (void)setupLoadedView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"pubInfo_Cell"];
    _tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pubInfo_Cell" forIndexPath:indexPath];
    PublishType *type = self.datas[indexPath.row];
    cell.textLabel.text = type.text;
    
    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
  
    PublishType *type = self.datas[indexPath.row];
    
    NSString *typeText = type.text;
    if ([typeText isEqualToString:@"房屋出售"]||[typeText isEqualToString:@"车位出售"]) {
        [self requestForsaleWithType:type];
    }else{
        [self requestForAsk:type];
    }
    
    
    
//    switch (indexPath.row) {
//        case 0:
//        {
//             houseRS.useType = BNPublishNextVCUseType_rent_house;
//        }
//            break;
//        case 1:
//        {
//             houseRS.useType = BNPublishNextVCUseType_sale_house;
//        }
//            break;
//        case 2:
//        {
//            houseRS.useType = BNPublishNextVCUseType_rent_car;
//        }
//            break;
//        case 3:
//        {
//            houseRS.useType = BNPublishNextVCUseType_sale_car;
//        }
//            break;
//        case 4:
//        {
//            houseRS.useType = PubForAskVCUseType_rent_house;
//        }
//            break;
//        case 5:
//        {
//            houseRS.useType = PubForAskVCUseType_sale_house;
//        }
//            break;
//        case 6:
//        {
//            houseRS.useType = PubForAskVCUseType_rent_car;
//        }
//            break;
//        case 7:
//        {
//            houseRS.useType = PubForAskVCUseType_sale_car;
//        }
//            break;
//            
//        default:
//            break;
//    }
   

}

- (void)requestPublishType
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi askTypeWithUserNum:[UserInfo sharedUserInfo].userId
                           success:^(NSDictionary *successData) {
                               NSLog(@"获取发布类型---->>>> %@",successData);
                               if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                   [SVProgressHUD dismiss];
                                   NSArray *returnData = [successData valueNotNullForKey:kRequestReturnData];
                                   for (int i = 0; i < returnData.count; i ++) {
                                       PublishType *type = [PublishType changeDicToType:returnData[i]];
                                       [weakSelf.datas addObject:type];
                                   }
                                   [weakSelf.tableView reloadData];
                                   
                               }else{
                                   NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                   [SVProgressHUD showErrorWithStatus:retMsg];
                               }
                           }
                            failed:^(NSError *error) {
                                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                
                            }];
    
}


#pragma mark - INIT - Request
- (void)requestForsaleWithType:(PublishType *)type{
    
//    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi saleHouseWithArticleID:type.typeId
                               success:^(NSDictionary *successData) {
                                   NSLog(@"租售信息---->>>> %@",successData);
                                   if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                       [SVProgressHUD dismiss];
                                       NSDictionary *returnData = [successData valueNotNullForKey:kRequestReturnData];
                                       
                                       NSMutableArray *theHouseTypes = [[NSMutableArray alloc] init];
                                       NSMutableArray *theDirections = [[NSMutableArray alloc] init];
                                       NSMutableArray *theDecorationTypes = [[NSMutableArray alloc] init];
                                       NSMutableArray *thePaytypes = [[NSMutableArray alloc] init];
                                       
                                       NSArray *types = [returnData valueForKey:@"types"];
                                       if ([types isKindOfClass:[NSArray class]] && types.count > 0) {
                                           for (int i = 0; i < types.count; i ++) {
                                               NSDictionary *dic = types[i];
                                               [theHouseTypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *directions = [returnData valueForKey:@"directions"];
                                       if ([directions isKindOfClass:[NSArray class]] && directions.count > 0) {
                                           for (int i = 0; i < directions.count; i ++) {
                                               NSDictionary *dic = directions[i];
                                               [theDirections addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *decorationTypes = [returnData valueForKey:@"decorationTypes"];
                                       if ([decorationTypes isKindOfClass:[NSArray class]] && decorationTypes.count > 0) {
                                           for (int i = 0; i < decorationTypes.count; i ++) {
                                               NSDictionary *dic = decorationTypes[i];
                                               [theDecorationTypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *payTypes = [returnData valueForKey:@"payTypes"];
                                       if ([payTypes isKindOfClass:[NSArray class]] && payTypes.count > 0) {
                                           for (int i = 0; i < payTypes.count; i ++) {
                                               NSDictionary *dic = payTypes[i];
                                               [thePaytypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       BNPublishNextVC *houseRS = [[BNPublishNextVC alloc] init];
                                       houseRS.houseTypes = theHouseTypes;
                                       houseRS.directions = theDirections;
                                       houseRS.decorationTypes = theDecorationTypes;
                                       houseRS.payTypes = thePaytypes;
                                       houseRS.type = type;
                                       [self pushViewController:houseRS animated:YES];
                                       
                                   }else{
                                       NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                   }
                                   
                               }
                                failed:^(NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                }];
    
}

- (void)requestForAsk:(PublishType *)type{
//    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [RequestApi askHouseWithArticleID:type.typeId
                               success:^(NSDictionary *successData) {
                                   NSLog(@"求租求购信息---->>>> %@",successData);
                                   if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                       [SVProgressHUD dismiss];
                                       NSDictionary *returnData = [successData valueNotNullForKey:kRequestReturnData];
                                       NSMutableArray *theHouseTypes = [[NSMutableArray alloc] init];
                                       NSMutableArray *theDirections = [[NSMutableArray alloc] init];
                                       NSMutableArray *theDecorationTypes = [[NSMutableArray alloc] init];
                                       NSMutableArray *thePaytypes = [[NSMutableArray alloc] init];
                                       
                                       NSArray *types = [returnData valueForKey:@"types"];
                                       if ([types isKindOfClass:[NSArray class]] && types.count > 0) {
                                           for (int i = 0; i < types.count; i ++) {
                                               NSDictionary *dic = types[i];
                                               [theHouseTypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *directions = [returnData valueForKey:@"directions"];
                                       if ([directions isKindOfClass:[NSArray class]] && directions.count > 0) {
                                           for (int i = 0; i < directions.count; i ++) {
                                               NSDictionary *dic = directions[i];
                                               [theDirections addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *decorationTypes = [returnData valueForKey:@"decorationTypes"];
                                       if ([decorationTypes isKindOfClass:[NSArray class]] && decorationTypes.count > 0) {
                                           for (int i = 0; i < decorationTypes.count; i ++) {
                                               NSDictionary *dic = decorationTypes[i];
                                               [theDecorationTypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       NSArray *payTypes = [returnData valueForKey:@"payTypes"];
                                       if ([payTypes isKindOfClass:[NSArray class]] && payTypes.count > 0) {
                                           for (int i = 0; i < payTypes.count; i ++) {
                                               NSDictionary *dic = payTypes[i];
                                               [thePaytypes addObject:[HouseTypeModel changeDicToModel:dic]];
                                           }
                                       }
                                       
                                       BNPublishNextVC *houseRS = [[BNPublishNextVC alloc] init];
                                       houseRS.houseTypes = theHouseTypes;
                                       houseRS.directions = theDirections;
                                       houseRS.decorationTypes = theDecorationTypes;
                                       houseRS.payTypes = thePaytypes;
                                       houseRS.type = type;
                                       [self pushViewController:houseRS animated:YES];
                                   }else{
                                       NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                   }
                                   
                               }
                                failed:^(NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                    
                                }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
