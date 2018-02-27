//
//  BNShareBaseViewController.m
//  ios
//
//  Created by xu jiayong on 15-6-7.
//  Copyright (c) 2015年 Boen. All rights reserved.
//

#import "BNShareBaseViewController.h"
#import "UMSocial.h"
#import "ShareSubmitView.h"
#import "ShareSheetView.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

@interface BNShareBaseViewController ()<ShareSheetViewDelegate, ShareSubmitViewDelegate>

@property (nonatomic) ShareSubmitView *shareView;
@property (nonatomic) ShareSheetView *shareSheetView;
@property (nonatomic) NSString *shareImgUrl;
@property (nonatomic) NSString *shareText;
@property (nonatomic) NSString *shareGoodsUrl;
@property (nonatomic) NSString *shareType;

@end

@implementation BNShareBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showShareViewWithText:(NSString *)text imgUrl:(NSString *)imgUrl goodsUrl:(NSString *)goodsUrl
{
    _shareText = text;
    _shareImgUrl = imgUrl;
    _shareGoodsUrl = goodsUrl;
//    if (!_shareSheetView) {
        self.shareSheetView = [[ShareSheetView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        self.shareSheetView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_shareSheetView];
//    }

    [self.shareSheetView appearAnimation];
}
#pragma mark - ShareSheetViewDelegate
- (void)ShareSheetViewDelegateBtn:(CustomShareButton *)button
{
    [_shareSheetView disAppearAnimation];
    NSLog(@"ShareSheetViewDelegateBtn--分享Btn-----");
    _shareType = @"";
    switch (button.butonType) {
        case SocialShareTypeWeiBo: {
            //新浪微博
            _shareType = UMShareToSina;
            break;
        }
        case SocialShareTypeWeiXinHY: {
            //微信好友
            _shareType = UMShareToWechatSession;
            break;
        }
        case SocialShareTypeWeiXinPYQ: {
            //微信朋友圈
            _shareType = UMShareToWechatTimeline;
            break;
        }
        case SocialShareTypeMobileQQ: {
            //手机QQ
            _shareType = UMShareToQQ;
            break;
        }
        case SocialShareTypeQQZone: {
            //QQ空间
            _shareType = UMShareToQzone;
            break;
        }
        case SocialShareTypeFaceBook: {
            _shareType = UMShareToFacebook;
            break;
        }
        case SocialShareTypeTwitter: {
            _shareType = UMShareToTwitter;
            break;
        }
        case SocialShareTypeTencent: {
            //腾讯微博
            _shareType = UMShareToTencent;
            break;
        }
        case SocialShareTypeRenren: {
            //人人
            _shareType = UMShareToRenren;
            break;
        }
        case SocialShareTypeDouban: {
            //豆瓣
            _shareType = UMShareToDouban;
            break;
        }
        case SocialShareTypeEmail: {
            //邮件
            _shareType = UMShareToEmail;
            break;
        }
        case SocialShareTypeSMS: {
            //短信
            _shareType = UMShareToSms;
            break;
        }
        case SocialShareTypeMore: {
            _shareType = @"more";
           // 创建内容
            NSArray *arrayOfActivityItems = [NSArray arrayWithObjects:_shareText, _shareImgUrl, _shareGoodsUrl, nil];
            if ([_shareImgUrl isEqualToString:@"UseLocalImageToShare"]) {
                arrayOfActivityItems = [NSArray arrayWithObjects:_shareText, [UIImage imageNamed:@"share.jpg"], _shareGoodsUrl, nil];
            }
            
            // 显示view controller
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems: arrayOfActivityItems applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:Nil];

            return;
        }
    }
        if ([_shareImgUrl isEqualToString:@"UseLocalImageToShare"]) {
            [self ShareSubmitViewDelegateSelectBtn:nil image:[UIImage imageNamed:@"欢迎页_1242x2208"] text:_shareText goodsUrl:_shareGoodsUrl imgUrl:@""];
        } else {
            NSString *shareTXT = [NSString stringWithFormat:@"%@",_shareText];

            UIImage *image ;
            if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_shareImgUrl]] || [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:_shareImgUrl]]) {
                UIImageView *imgview = [[UIImageView alloc]init];
                [imgview sd_setImageWithURL:[NSURL URLWithString:_shareImgUrl]];

                image = imgview.image;
                if (!image) {
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImgUrl]];
                    image = [UIImage imageWithData:imgData];
                }
            } else {
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImgUrl]];
                image = [UIImage imageWithData:imgData];
            }
            
            
            [self ShareSubmitViewDelegateSelectBtn:nil image:image text:shareTXT goodsUrl:_shareGoodsUrl imgUrl:_shareImgUrl];
        }
        
  
   
    
}
#pragma mark - ShareSubmitViewDelegate
-(void)ShareSubmitViewDelegateSelectBtn:(ShareSubmitView *)selfView image:(id)image text:(NSString *)text goodsUrl:(NSString *)goodsUrl imgUrl:(NSString *)imgUrl
{
    NSString *shareTXT = [NSString stringWithFormat:@"%@",text];
    NSLog(@"_shareType---%@", _shareType);
    NSString *shareTitle = @"春哥";
    
    if ([_shareType isEqualToString:UMShareToWechatSession]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareGoodsUrl;
        
    } else if ([_shareType isEqualToString:UMShareToWechatTimeline]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareGoodsUrl;
        
    } else if ([_shareType isEqualToString:UMShareToQzone]) {
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = _shareGoodsUrl;
        
    }else if ([_shareType isEqualToString:UMShareToQQ]) {
        [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qqData.url = _shareGoodsUrl;
    }else if ([_shareType isEqualToString:UMShareToSms]) {
        [UMSocialData defaultData].extConfig.smsData.snsName = shareTitle;
        [UMSocialData defaultData].extConfig.smsData.shareText = shareTXT;
        [UMSocialData defaultData].extConfig.smsData.shareImage = image;
    }else if ([_shareType isEqualToString:UMShareToSina]){
        UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:_shareGoodsUrl];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:_shareGoodsUrl];
        [self shareToSinaWeibo:selfView image:image text:shareTXT goodsUrl:goodsUrl imgUrl:imgUrl resource:resource];
        return;
    }
    
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[_shareType] content:shareTXT image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//        NSLog(@"shareResponse--%@",shareResponse);
//        NSLog(@"shareResponse.message--%@",shareResponse.message);
        
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"\n分享成功\n"];
            if (selfView) {
                [selfView disAppearAnimation];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"\n分享失败\n"];
//            NSLog(@"分享失败！--%ld", (long)shareResponse.responseCode);
        }
        
        
    }];

    
}

//分享到新浪微博（网页）
- (void)shareToSinaWeibo:(ShareSubmitView *)selfView image:(id)image text:(NSString *)text goodsUrl:(NSString *)goodsUrl imgUrl:(NSString *)imgUrl resource:(UMSocialUrlResource *)resource
{
    NSString *theText = [NSString stringWithFormat:@"%@\n%@",text,_shareGoodsUrl];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:theText image:image location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){

        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"\n分享成功\n"];
            if (selfView) {
                [selfView disAppearAnimation];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"\n分享失败\n"];
        }
    }];

}


@end
