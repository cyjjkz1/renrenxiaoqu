//
//  ShareSheetView.m
//  ios
//
//  Created by xu jiayong on 15-4-5.
//  Copyright (c) 2015年 Boen. All rights reserved.
//

#import "ShareSheetView.h"
//#import "WXApi.h"

@interface ShareSheetView ()
{
    UIButton *defaultBtn;
}
@property (nonatomic) UIView *baseTransformView;

@property (nonatomic) UIView *whiteView;
@property (nonatomic) UIButton *cancelBtn;
@property (nonatomic) NSMutableArray *imgNameAry;
@property (nonatomic) NSMutableArray *nameAry;

@end

@implementation ShareSheetView
static CGFloat whiteViewHeight;

- (BOOL)isInstallApp:(NSString *)appurl
{
    NSURL *Url = [NSURL URLWithString:appurl];
    BOOL hasInstall = [[UIApplication sharedApplication] canOpenURL:Url];
    return hasInstall;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.imgNameAry = [@[] mutableCopy];
        self.nameAry = [@[] mutableCopy];
        
        if ([self isInstallApp:@"http://mqq://"]) {
            //是否安装QQ
            [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_qq_icon"];
            [_nameAry addObject:@"QQ"];
        }
        
        if ([self isInstallApp:@"http://sinaweibo://"]) {
            //是否安装sina微博
            [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_sina_icon"];
            [_nameAry addObject:@"新浪微博"];
        }
        
        if ([WXApi isWXAppInstalled]) {
            //是否安装微信
            [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_wechat_icon"];
            [_nameAry addObject:@"微信好友"];
        }
     
        if ([WXApi isWXAppInstalled]) {
            //是否安装微信
        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_wechat_timeline_icon"];
        [_nameAry addObject:@"朋友圈"];
        }
        
        
        //        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_sms_icon"];
        //        [_nameAry addObject:@"信息"];
        
//        if ([self isInstallApp:@"http://mqq://"]) {
//            //是否安装QQ
//            [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_qzone_icon"];
//            [_nameAry addObject:@"QQ空间"];
//        }
//        if ([self isInstallApp:@"http://sinaweibo://"]) {
//            //是否安装sina微博
//            [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_sina_icon"];
//            [_nameAry addObject:@"新浪微博"];
//        }
     
//        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_tencent_icon"];
//        [_nameAry addObject:@"腾讯微博"];
//        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_email_icon"];
//        [_nameAry addObject:@"邮件"];
        
//        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_renren_icon"];
//        [_nameAry addObject:@"人人网"];
//        [_imgNameAry addObject:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_douban_icon"];
//        [_nameAry addObject:@"豆瓣网"];
//        [_imgNameAry addObject:@"more"];
//        [_nameAry addObject:@"更多"];
        
        whiteViewHeight = _nameAry.count < 5 ? 100*BILI_WIDTH : _nameAry.count < 10 ? 180*BILI_WIDTH : 260*BILI_WIDTH;
        
        whiteViewHeight += 80 * BILI_WIDTH;

        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.0];
        
        self.baseTransformView = [[UIView alloc]initWithFrame:frame];
        _baseTransformView.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseTransformView];
        _baseTransformView.transform = CGAffineTransformMakeTranslation(0, 0);

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation)];
        [self addGestureRecognizer:tap];
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-whiteViewHeight, SCREEN_WIDTH, whiteViewHeight)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 3;
        _whiteView.layer.masksToBounds = YES;
        [_baseTransformView addSubview:_whiteView];
    
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation2)];
        [_whiteView addGestureRecognizer:tap2];
        
        //4个按钮
        CGFloat originY = 10;
        CGFloat buttonHeight = 80*BILI_WIDTH;
       
        
        int j = 0; //行数
        CGFloat originX = 15*BILI_WIDTH; CGFloat maxY = 0.0;
        for (int i=0; i < _nameAry.count; i++) {
            if (i > 3) {
                j = 1;
            }
            if (i > 7) {
                j = 2;
            }
            if (j == 1 && i == 4) {
                originX = 15*BILI_WIDTH;
            }
            if (j == 2 && i == 8) {
                originX = 15*BILI_WIDTH;
            }
            CustomShareButton *sinaWeiboBtn = [CustomShareButton buttonWithType:UIButtonTypeCustom];
            sinaWeiboBtn.tag = 100+i;
            sinaWeiboBtn.frame = CGRectMake(originX, originY+j*buttonHeight, (_whiteView.frame.size.width-2*15*BILI_WIDTH)/4+0.5, buttonHeight);
            UIImage *image1 = [Tools imageWithColor:[UIColor whiteColor] andSize:sinaWeiboBtn.frame.size];
            UIImage *image2 = [Tools imageWithColor:[UIColor groupTableViewBackgroundColor] andSize:sinaWeiboBtn.frame.size];
            [sinaWeiboBtn setBackgroundImage:image1 forState:UIControlStateNormal];
            [sinaWeiboBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
            [sinaWeiboBtn setImage:[UIImage imageNamed:_imgNameAry[i]] forState:UIControlStateNormal];
            [sinaWeiboBtn setTitle:_nameAry[i] forState:UIControlStateNormal];
            [sinaWeiboBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [sinaWeiboBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_whiteView addSubview:sinaWeiboBtn];
            
            maxY = sinaWeiboBtn.maxY;
            
            SocialShareType shareType;
            if ([_nameAry[i] isEqualToString:@"新浪微博"]) {
                shareType = SocialShareTypeWeiBo;
            } else if ([_nameAry[i] isEqualToString:@"微信"]) {
                shareType = SocialShareTypeWeiXinHY;
            } else if ([_nameAry[i] isEqualToString:@"朋友圈"]) {
                shareType = SocialShareTypeWeiXinPYQ;
            } else if ([_nameAry[i] isEqualToString:@"QQ空间"]) {
                shareType = SocialShareTypeQQZone;
            } else if ([_nameAry[i] isEqualToString:@"QQ"]) {
                shareType = SocialShareTypeMobileQQ;
            } else if ([_nameAry[i] isEqualToString:@"腾讯微博"]) {
                shareType = SocialShareTypeTencent;
            } else if ([_nameAry[i] isEqualToString:@"人人网"]) {
                shareType = SocialShareTypeRenren;
            } else if ([_nameAry[i] isEqualToString:@"豆瓣网"]) {
                shareType = SocialShareTypeDouban;
            }  else if ([_nameAry[i] isEqualToString:@"邮件"]) {
                shareType = SocialShareTypeEmail;
            }  else if ([_nameAry[i] isEqualToString:@"信息"]) {
                shareType = SocialShareTypeSMS;
            } else if ([_nameAry[i] isEqualToString:@"Facebook"]) {
                shareType = SocialShareTypeFaceBook;
            } else if ([_nameAry[i] isEqualToString:@"Twitter"]) {
                shareType = SocialShareTypeTwitter;
            } else if ([_nameAry[i] isEqualToString:@"更多"]) {
                shareType = SocialShareTypeMore;
            }
            sinaWeiboBtn.butonType = shareType;
            
            originX += sinaWeiboBtn.frame.size.width;
            
        }
       
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 201;
        _cancelBtn.frame = CGRectMake(20*BILI_WIDTH, maxY + 20 * BILI_WIDTH , SCREEN_WIDTH - 40 * BILI_WIDTH, 40*BILI_WIDTH);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.cornerRadius = 3;
        _cancelBtn.layer.masksToBounds = YES;
        
        [_whiteView addSubview:_cancelBtn];
//        [_baseTransformView addSubview:_cancelBtn];

    }
    return self;
}

- (void)appearAnimation
{
    self.hidden = NO;
//    self.alpha = 0.0;
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];

        _baseTransformView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
- (void)disAppearAnimation
{
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.0];
        _baseTransformView.transform = CGAffineTransformMakeTranslation(0, whiteViewHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}
- (void)disAppearAnimation2
{
    
}
- (void)buttonAction:(CustomShareButton *)button
{
    
    if (button.tag == 201) {
        [self disAppearAnimation];
    } else{
         if([self.delegate respondsToSelector:@selector(ShareSheetViewDelegateBtn:)]) {
             NSLog(@"shareType   -->>>%ld",(long)button.butonType);
             
             [self.delegate ShareSheetViewDelegateBtn:button];
         }}
}

@end
