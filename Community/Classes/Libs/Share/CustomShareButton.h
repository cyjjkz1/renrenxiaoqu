//
//  CustomShareButton.h
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SocialShareType) {
    SocialShareTypeWeiBo,     //新浪微博
    SocialShareTypeWeiXinHY,  //微信好友
    SocialShareTypeWeiXinPYQ, //微信朋友圈
    SocialShareTypeMobileQQ,  //手机qq
    SocialShareTypeQQZone,    //qq空间
    SocialShareTypeFaceBook,
    SocialShareTypeTwitter,
    SocialShareTypeTencent,   //腾讯微博
    SocialShareTypeRenren,    //人人网
    SocialShareTypeDouban,    //豆瓣
    SocialShareTypeEmail,     //邮件
    SocialShareTypeSMS,       //短信
    SocialShareTypeMore,
};

extern NSString *const UMShareToDouban;
@interface CustomShareButton : UIButton

@property (nonatomic, assign) SocialShareType butonType;

-(CGRect) imageRectForContentRect:(CGRect)contentRect;

-(CGRect) titleRectForContentRect:(CGRect)contentRect;

@end
