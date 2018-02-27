//
//  AccountInfoViewController.m
//  Community
//
//  Created by mac1 on 16/6/29.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "PesonInfoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "ModifyAccoutInfoVC.h"
#import "ModifyPasswordVC.h"
#import "BNUploadAvatarProgressView.h"
#import "BNUploadTools.h"
#import "ModifyAddressVC.h"
#import "cc_macro.h"
@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, weak) UIView *tableHeaderView;
@property (nonatomic, weak) UIImageView *avatar;

@property (nonatomic, strong) UIImage *selectImage;//选择的照片
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectedTag;

@end

@implementation AccountInfoViewController

static NSString *const AccountInfoCellID = @"AccountInfoCellID";

- (NSMutableArray *)datas
{
    if (!_datas) {
//        NSString *path = [[Tools getDocumentPath] stringByAppendingPathComponent:@"avatar"];
//        NSData *imageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//        if (imageData) {
//            UIImage *image = [UIImage imageWithData:imageData];
//            _datas = @[@[@{@"title":@"头像", @"image":image}, @{@"title":@"姓名"}, @{@"title":@"性别"}], @[@{@"title":@"身份"}, @{@"title":@"小区"}], @[@{@"title":@"手机"},@{@"title":@"密码"}]].mutableCopy;
//        }else{
//            _datas = @[@[@{@"title":@"头像"}, @{@"title":@"姓名"}, @{@"title":@"性别"}], @[@{@"title":@"身份"}, @{@"title":@"小区"}], @[@{@"title":@"手机"},@{@"title":@"密码"}]].mutableCopy;
//        }
        _datas = @[@[@{@"title":@"姓名"}, @{@"title":@"性别"}], @[@{@"title":@"身份"}, @{@"title":@"地址"}], @[@{@"title":@"手机"},@{@"title":@"密码"}]].mutableCopy;
    }
    return _datas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"账户信息";
    [self setupLoadedView];
    
}

- (void)setupLoadedView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  63 * BILI_WIDTH)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAcion)];
    [headView addGestureRecognizer:tap];
    
    UILabel *avatarTitle = [[UILabel alloc] initWithFrame:CGRectMake(22 * BILI_WIDTH, 0, 100, 15 * BILI_WIDTH)];
    avatarTitle.text = @"头像";
    avatarTitle.centerY = headView.centerY;
    avatarTitle.textColor = [UIColor lightGrayColor];
    avatarTitle.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [headView addSubview:avatarTitle];
    
    UIImageView *avatar = [[UIImageView alloc] init];
    avatar.frame = CGRectMake(SCREEN_WIDTH - 60 * BILI_WIDTH, 10 * BILI_WIDTH, 45 * BILI_WIDTH, 45 * BILI_WIDTH);
    avatar.layer.cornerRadius = 45 * BILI_WIDTH/2.0;
    avatar.layer.masksToBounds = YES;
    [avatar sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [headView addSubview:avatar];
    _avatar = avatar;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT -NaviHeight)];
    tableView.rowHeight = 38 * BILI_WIDTH;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: tableView];
    _tableView = tableView;
    tableView.tableHeaderView = headView;
    _tableHeaderView = headView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    [tableView registerClass:[PesonInfoCell class] forCellReuseIdentifier:AccountInfoCellID];

}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.datas[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PesonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountInfoCellID forIndexPath:indexPath];
    
    NSArray *sections = self.datas[indexPath.section];
    
    [cell setupCellWithDic:sections[indexPath.row] indexPath:indexPath sectionTotleRows:sections.count];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8 * BILI_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8 * BILI_WIDTH)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38 * BILI_WIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {//姓名
                    ModifyAccoutInfoVC *mVC = [[ModifyAccoutInfoVC alloc] init];
                    mVC.useStyle = ModifyAccoutInfoVCUseStyleChangeName;
                    mVC.editFinishBlock =^(NSString *text){
                        //改变姓名请求
                        [self changeUserInfoWithName:text sex:nil status:nil villige:nil success:^(NSDictionary *successData) {
                            if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                [self.navigationController popViewControllerAnimated:YES];
                                [UserInfo sharedUserInfo].userName = text;
                                [self.tableView reloadData];
                            }else{
                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                [SVProgressHUD showErrorWithStatus:retMsg];
                            }
                            
                        } failed:^(NSError *error) {
                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                        }];
                    };
                    [self pushViewController:mVC animated:YES];
                }
                    break;
                case 1:
                {//性别
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女", @"男", nil];
                    self.selectedTag = 888;
                    [sheet showInView:self.view];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {//身份
//                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"业主", @"租客", nil];
//                    self.selectedTag = 999;
//                    [sheet showInView:self.view];
                }
                    break;
                case 1:
                {//小区
                    //获取楼宇信息
                    __weak typeof(self) weakSelf = self;
                    [RequestApi getBuildingInfoSuccess:^(NSDictionary *successData) {
                        NSLog(@"获取楼宇信息---->>>>%@",successData);
                        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                            [SVProgressHUD dismiss];
                            NSMutableArray *buildNames = @[].mutableCopy;
                            NSArray *data = [successData valueNotNullForKey:@"data"];
                            for (int i = 0; i < data.count; i ++) {
                                NSDictionary *dic = data[i];
                                NSString *name = [dic valueNotNullForKey:@"buildingName"];
                                [buildNames addObject:name];
                            }
                            ModifyAddressVC *mVC = [[ModifyAddressVC alloc] init];
                            mVC.buildings = buildNames;
                            mVC.editFinishBlock = ^(NSString *budingName, NSString *roomNumber){
                              
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                [weakSelf.tableView reloadData];
                            };
                            [weakSelf pushViewController:mVC animated:YES];
                            
                        }else{
                            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                            [SVProgressHUD showErrorWithStatus:retMsg];
                        }
                        
                    } failed:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                    }];
                    
//                    ModifyAccoutInfoVC *mVC = [[ModifyAccoutInfoVC alloc] init];
//                    mVC.useStyle = ModifyAccoutInfoVCUseStyleChangeVillige;
//                    mVC.editFinishBlock = ^(NSString *text){
//                        //改变小区请求
//                        [self changeUserInfoWithName:nil sex:nil status:nil villige:text success:^(NSDictionary *successData) {
//                            if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
//                                [self.navigationController popViewControllerAnimated:YES];
//                                [UserInfo sharedUserInfo].villige = text;
//                                [self.tableView reloadData];
//                            }else{
//                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
//                                [SVProgressHUD showErrorWithStatus:retMsg];
//                            }
//                            
//                        } failed:^(NSError *error) {
//                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
//                        }];
//                    };
//                    
//                    [self pushViewController:mVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {//手机
                    
                }
                    break;
                case 1:
                {//密码（修改密码）
                    ModifyPasswordVC *modifyPswVC = [[ModifyPasswordVC alloc] init];
                    [self pushViewController:modifyPswVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)tapAcion
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择上传头像方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    if (self.selectedTag == 888) {
        
        //服务器  0女  1男
        NSString *sex = buttonIndex == 1 ? @"男" : @"女";
        //改变性别请求
        [self changeUserInfoWithName:nil sex:[NSString stringWithFormat:@"%ld",(long)buttonIndex] status:nil villige:nil success:^(NSDictionary *successData) {
            if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [UserInfo sharedUserInfo].sex = sex;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:0];
            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
            
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];

    }else if (self.selectedTag == 999){
         // 0业主  1 租客
        NSString *stauts = buttonIndex == 0 ? @"业主" : @"租客";
        
        //改变身份请求
        [UserInfo sharedUserInfo].status = stauts;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:0];
        
        
        
    }else{
        // 0 相机  1 相册
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if(author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil] show];
            return;
        }
        UIPasteboard* pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = @"#1";
        _imagePicker = [[UIImagePickerController alloc]  init];
        _imagePicker.sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if (buttonIndex == 0) {
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
   
}


#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {//如果是照片
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing)
        {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }
        else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        
        BNUploadAvatarProgressView *progressView = [[BNUploadAvatarProgressView alloc] initWithFrame:_avatar.frame];
        progressView.layer.cornerRadius = _avatar.w/2.0;
        progressView.layer.masksToBounds = YES;
        progressView.backgroundColor = [UIColor clearColor];
        [_tableHeaderView addSubview:progressView];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        [[BNUploadTools shareInstance] uploadUserAvatarWithData:imageData success:^(id responseObject) {
            if ([[responseObject valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
                _avatar.image = image;
                [progressView startAnimation];
//                if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
//                    pasteBoard.string = [pasteBoard.string stringByAppendingString:@"#8"];
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
//                    });
//                }
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[kRequestRetMessage]];
                [progressView stopAnimation];
            }

            
        } progress:^(NSProgress *uploadProgress) {
            
            
        } failure:^(NSError *error) {
            NSLog(@"upload avatar error --->>>>> %@",error);
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
             [progressView stopAnimation];
        }];
    }
    _imagePicker = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


//请求
- (void)changeUserInfoWithName:(NSString *)userName
                           sex:(NSString *)sex
                        status:(NSString *)status
                       villige:(NSString *)villige
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod
{
    [RequestApi modifyUserInfoWithUserId:[UserInfo sharedUserInfo].userId name:userName gender:sex buildingName:villige status:status password:nil success:successMethod failed:errorMethod];
}


#pragma mark - 接口请求
- (void)requestUserInfo{
    [RequestApi getUserInfoWithUserId:[UserInfo sharedUserInfo].userId
                              success:^(NSDictionary *successData) {
                                  if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                      [SVProgressHUD dismiss];
                                      //请求成功处理
                                      NSDictionary *retData = successData[@"data"];
                                      if (retData.count > 0) {
                                          [[UserInfo sharedUserInfo] setupDataWithDic:retData];
                                      }
                                  }
                              }
                               failed:^(NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"稍后重试"];
                               }];
}


@end
