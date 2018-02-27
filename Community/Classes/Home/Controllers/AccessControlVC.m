//
//  AccessControlVC.m
//  Community
//
//  Created by mac1 on 16/6/27.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AccessControlVC.h"
#import "LBXScanWrapper.h"
#import "cc_macro.h"
@interface AccessControlVC ()

@end

@implementation AccessControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"门禁";
    
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    self.telManagerBtn.hidden = NO;
    
    NSString *urlStr = @"https://www.baidu.com";
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight);
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:coverView];
    
    
    CGFloat centerViewH = 213 * BILI_WIDTH;
    UIView *centerWhiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - centerViewH) * 0.5, (coverView.h - centerViewH) * 0.5, centerViewH, centerViewH)];
    centerWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerWhiteView];
    
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * BILI_WIDTH,30 * BILI_WIDTH, centerViewH - 60*BILI_WIDTH , centerViewH - 60*BILI_WIDTH )];
    UIImage *qrImg = [LBXScanWrapper createQRWithString:urlStr size:qrImageView.bounds.size];
    qrImageView.image = qrImg; //如果需要在二维码中间加入logo则打开下面两行注释----->>>>>>>
    //    UIImage *logoImg = [UIImage imageNamed:@"icon_erweima"];
    //qrImageView.image = [LBXScanWrapper addImageLogo:qrImg centerLogoImage:logoImg logoSize:CGSizeMake(30 * NEW_BILI, 30 * NEW_BILI)];
    [centerWhiteView addSubview:qrImageView];
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = CGRectMake(0, qrImageView.maxY + 10 * BILI_WIDTH, centerViewH, 10 * BILI_WIDTH);
    reloadBtn.userInteractionEnabled = NO;
    [reloadBtn setTitle:@"每一个小时自动刷新" forState:UIControlStateNormal];
    [reloadBtn setImage:[UIImage imageNamed:@"refresh_btn"] forState:UIControlStateNormal];
    [reloadBtn setTitleColor:UIColor_Gray_Text forState:UIControlStateNormal];
    [reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [reloadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    reloadBtn.titleLabel.font = [UIFont systemFontOfSize:10 * BILI_WIDTH];
    [centerWhiteView addSubview:reloadBtn];

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
