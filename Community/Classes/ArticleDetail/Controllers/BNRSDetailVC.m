//
//  BNRSDetailVC.m
//  Community
//
//  Created by mac1 on 2016/10/17.
//  Copyright © 2016年
//

#import "BNRSDetailVC.h"
#import <MessageUI/MessageUI.h>
#import "BNReportViewController.h"
#import "cc_macro.h"
@interface BNRSDetailVC ()<MFMessageComposeViewControllerDelegate>

@end

@implementation BNRSDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
    
}
- (void)setupLoadedView
{
    [super setupLoadedView];
    self.navigationTitle = _model.type;
    
    self.baseScrollView.backgroundColor = UIColor_Gray_BG;
    
    
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = 23*BILI_WIDTH;
    collect.frame = CGRectMake(SCREEN_WIDTH - buttonWidth - 13, (44-buttonWidth) * 0.5, buttonWidth, buttonWidth);
    [collect setBackgroundImage:[UIImage imageNamed:@"collection_unselected"] forState:UIControlStateNormal];
    [collect setBackgroundImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
    [collect addTarget:self action:@selector(collectionAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:collect];
    collect.selected = [LCDataTool isCollect:self.model];
    
    
    //图片
    __block CGFloat imageMaxY = 0;
    if (_model.imageUrl.length > 0 && ![_model.imageUrl isEqualToString:@"null"]) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_model.imageUrl] options:SDWebImageDelayPlaceholder progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                return;
            }
            
            if (finished) {
                CGSize imageSize = image.size;
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/imageSize.width) * imageSize.height)];
                imageView.image = image;
                [self.baseScrollView addSubview:imageView];
                
                imageMaxY = imageView.maxY;
//                [self setupOtherViewsWithImageMaxY:imageMaxY];
            }
            
             [self setupOtherViewsWithImageMaxY:imageMaxY];
            
        }];
    }else{
        [self setupOtherViewsWithImageMaxY:imageMaxY];
    }
//    CGFloat imageMaxY = 0;
//    if (_model.imageUrl.length > 0 && ![_model.imageUrl isEqualToString:@"null"]) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 * NEW_BILI)];
//        //    imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.baseScrollView addSubview:imageView];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"default_room"]];
//        imageMaxY = imageView.maxY;
//    }
    
 

}

- (void)setupOtherViewsWithImageMaxY:(CGFloat)imageMaxY
{
    
    UIView *whiteBGView1 = [[UIView alloc] initWithFrame:CGRectMake(0, imageMaxY + 10, SCREEN_WIDTH, 218 * NEW_BILI)];
    whiteBGView1.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBGView1];
    
    CGFloat originY = 0.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, whiteBGView1.w, 20 * NEW_BILI)];
    titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = _model.title;
    [whiteBGView1 addSubview:titleLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 * NEW_BILI, SCREEN_WIDTH - 20, 15)];
    dateLabel.textColor = UIColor_Gray_Text;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = _model.date;
    [whiteBGView1 addSubview:dateLabel];
    originY = dateLabel.maxY;
    
    
    NSMutableArray *infoArr = @[].mutableCopy;
    if (![_model.houseType isEqualToString:@"null"]) {
        [infoArr addObject:_model.houseType];
    }
    if (![_model.decorationType isEqualToString:@"null"]) {
        [infoArr addObject:_model.decorationType];
    }
    if (![_model.direction isEqualToString:@"null"]) {
        [infoArr addObject:_model.direction];
    }
    if (![_model.payType isEqualToString:@"null"]) {
        [infoArr addObject:_model.payType];
    }
    
    CGFloat lastMaxX = 0;
    originY += 12 * NEW_BILI;
    for (int i = 0 ; i < infoArr.count; i ++) {
        if (i == 0) {
            lastMaxX = 10;
        }
        NSString *text = infoArr[i];
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 * NEW_BILI]}];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lastMaxX, originY, atts.size.width + 14, 25 * NEW_BILI)];
        label.font = [UIFont systemFontOfSize:13 * NEW_BILI];
        label.textColor = BNColorRGB(255, 151, 0);
        label.layer.borderWidth = 1;
        label.layer.borderColor =  BNColorRGB(255, 151, 0).CGColor;
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        [whiteBGView1 addSubview:label];
        
        lastMaxX = label.maxX + 15;
        if (i == infoArr.count - 1) {
            originY = label.maxY;
        }
    }
    
    originY += 16*NEW_BILI;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, originY, SCREEN_WIDTH - 20, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBGView1 addSubview:line];
    originY += CGRectGetHeight(line.frame) + 22 * NEW_BILI;
    
    UILabel *authorName = [[UILabel alloc] initWithFrame:CGRectMake(10, originY, 200, 15*BILI_WIDTH)];
    authorName.font = [UIFont systemFontOfSize:15*NEW_BILI];
    authorName.textColor = [UIColor blackColor];
    authorName.text = _model.authorName;
    [whiteBGView1 addSubview:authorName];
    originY += CGRectGetHeight(authorName.frame) + 10 * NEW_BILI;
    
    UILabel *authorMobile = [[UILabel alloc] initWithFrame:CGRectMake(10, originY, 200, 15*BILI_WIDTH)];
    authorMobile.font = [UIFont systemFontOfSize:15*NEW_BILI];
    authorMobile.textColor = UIColorFromRGB(0x663300);
    authorMobile.text = _model.authorMobile;
    [whiteBGView1 addSubview:authorMobile];
    originY += CGRectGetHeight(authorMobile.frame);
    
    whiteBGView1.h = originY + 18 * NEW_BILI;
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(260 * NEW_BILI, line.maxY + 23 * NEW_BILI, 36, 36);
    msgBtn.tag = 666;
    [msgBtn setImage:[UIImage imageNamed:@"to_sms"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView1 addSubview:msgBtn];
    
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telBtn.frame = CGRectMake(msgBtn.maxX + 15 * NEW_BILI, msgBtn.y, 36, 36);
    telBtn.tag = 888;
    [telBtn setImage:[UIImage imageNamed:@"to_tel"] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView1 addSubview:telBtn];
    
    UIView *whiteBGView2 = [[UIView alloc] initWithFrame:CGRectMake(0, whiteBGView1.maxY + 10, SCREEN_WIDTH, 94 * NEW_BILI)];
    whiteBGView2.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBGView2];
    
    UILabel *desTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH, 20 * NEW_BILI)];
    desTitleLbl.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    desTitleLbl.textColor = [UIColor blackColor];
    desTitleLbl.text = @"描述";
    [whiteBGView2 addSubview:desTitleLbl];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, desTitleLbl.maxY + 18  * NEW_BILI, SCREEN_WIDTH - 20, 0.5)];
    line2.backgroundColor = UIColor_GrayLine;
    [whiteBGView2 addSubview:line2];
    
    UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.maxY + 15 * NEW_BILI, SCREEN_WIDTH - 20,20)];
    desLbl.font = [UIFont systemFontOfSize: 15 * NEW_BILI];
    desLbl.textColor = [UIColor blackColor];
    desLbl.numberOfLines = 0;
    desLbl.text = _model.theDescription;
    [whiteBGView2 addSubview:desLbl];
    [desLbl sizeToFit];
    
    
    
    whiteBGView2.h = desLbl.maxY + 17 * NEW_BILI;
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(SCREEN_WIDTH - 135, whiteBGView2.maxY+ 10, 120, 30);
    [reportBtn setuporangeBtnTitle:@"举报此信息" enable:YES];
    [reportBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * NEW_BILI]];
    [reportBtn addTarget:self action:@selector(reportAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:reportBtn];
    
    
    if (reportBtn.maxY + 10 > SCREEN_HEIGHT - NaviHeight - TabbarHeight) {
        self.baseScrollView.contentSize = CGSizeMake(0, reportBtn.maxY + 59);
    }
}


- (void)contactAction:(UIButton *)button
{
    if (button.tag == 666) {
        //发短信
        if([MFMessageComposeViewController canSendText]){
            MFMessageComposeViewController *messageController=[[MFMessageComposeViewController alloc]init];
            //收件人
            messageController.recipients = @[_model.authorMobile];
            //信息正文
            messageController.body = @"你好！我是从社区管家上看到你发布的信息的。我们可以聊一下吗？";
            //设置代理,注意这里不是delegate而是messageComposeDelegate
            messageController.messageComposeDelegate = self;
            [self presentViewController:messageController animated:YES completion:nil];
            
        }
        
    }else{
        //打电话
        UIWebView *webView = [[UIWebView alloc]init];
        NSString *telPhone = [NSString stringWithFormat:@"tel://%@",_model.authorMobile];
        NSURL *url = [NSURL URLWithString:telPhone];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *string = nil;
    NSInteger status = 0;
    switch (result) {
        case MessageComposeResultSent:
            string = @"发送成功";
            status = 1;
           
            break;
        case MessageComposeResultCancelled:
            string = @"取消发送";
                       break;
        default:
            string = @"发送失败";
            
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (status == 1) {
             [SVProgressHUD showSuccessWithStatus:string];
        }else{
            [SVProgressHUD showErrorWithStatus:string];

        }
    }];
}

- (void)collectionAcion:(UIButton *)button
{
    if (button.isSelected) { // 取消收藏
        [LCDataTool removeCollect:self.model];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
        
    } else { // 收藏
        [LCDataTool addInfo:self.model];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }
    
    // 按钮的选中取反
    button.selected = !button.isSelected;
}

//举报
- (void)reportAcion
{
    BNReportViewController *reportVC = [[BNReportViewController alloc] init];
    reportVC.model = _model;
    [self pushViewController:reportVC animated:YES];
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
