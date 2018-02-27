//
//  BNReportViewController.m
//  Community
//
//  Created by mac1 on 2016/11/17.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNReportViewController.h"
#import "PlaceholderTextView.h"
#import "KeychainItemWrapper.h"
#import "cc_macro.h"
@interface BNReportViewController ()<UITextViewDelegate>
@property (nonatomic, weak) UIButton *reportBtn;

@end

@implementation BNReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"举报";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    NSString *tipsMsg = [NSString stringWithFormat:@"确认举报 “%@” 信息",_model.title];
    CGFloat h = [Tools caleHeightWithTitle:tipsMsg font:[UIFont systemFontOfSize:14 * NEW_BILI] width:SCREEN_WIDTH - 30];
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, h)];
    tips.textColor = UIColor_Gray_Text;
    tips.text = tipsMsg;
    tips.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    [self.baseScrollView addSubview:tips];
    
    PlaceholderTextView *textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(tips.x , tips.maxY + 15, tips.w, 120)];
    textView.placeholder = @"请说明举报原因";
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.layer.borderColor = BNColorRGB(255, 151, 0).CGColor;
    textView.layer.borderWidth = 0.5;
    textView.delegate = self;
    [self.baseScrollView addSubview:textView];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(12, textView.maxY + 15, textView.w, 40);
    [reportBtn setuporangeBtnTitle:@"提 交" enable:NO];
    [reportBtn addTarget:self action:@selector(reportBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:reportBtn];
    _reportBtn = reportBtn;
    
    if (reportBtn.maxY > SCREEN_HEIGHT - NaviHeight) {
        self.baseScrollView.contentSize = CGSizeMake(0, reportBtn.maxY + 20);
    }
    
}

- (void)textViewDidChange:(UITextView *)textView;
{
    _reportBtn.enabled = textView.text.length > 0;
}

- (void)reportBtnAcion
{
    //举报
    [SVProgressHUD showWithStatus:@"请稍后..."];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
    NSString *userId = [keychain objectForKey:(id)kSecValueData];
    //保存到单例类
    UserInfo *user = [UserInfo sharedUserInfo];
    user.userId = userId;
    [RequestApi getUserInfoWithUserId:userId success:^(NSDictionary *successData) {
        NSLog(@"举报--->>>>%@",successData);
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *data = [successData valueNotNullForKey:kRequestReturnData];
            
            [user setupDataWithDic:data];
            [SVProgressHUD showSuccessWithStatus:@"提交成功，我们会在24小时对该信息进行处理，感谢您的举报"];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

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
