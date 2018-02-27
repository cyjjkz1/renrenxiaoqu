//
//  Defines.h
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#ifndef NewWallet_Defines_h
#define NewWallet_Defines_h



//导航和状态栏高度
#define NAVIGATION_STATUSBAR_HEIGHT (44+20)

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//不同屏幕相对320的比例
#define BILI_WIDTH ([UIScreen mainScreen].bounds.size.width/320.0)

//不同屏幕相对375的比例
#define NEW_BILI ([UIScreen mainScreen].bounds.size.width/375.0)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BNColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.f]

//常用颜色值
#define UIColor_NewBlueColor UIColorFromRGB(0x448aff)

#define UIColor_Gray_BG           UIColorFromRGB(0xf3f3f3)//0xececec
#define UIColor_Button_Disable    UIColorFromRGB(0xcfd8dc)
#define UIColor_Button_Normal       UIColorFromRGB(0x448aff)
#define UIColor_Button_HighLight    UIColorFromRGB(0x2073fe)
#define UIColor_Blue_BarItemText  UIColorFromRGB(0x1178e7)
#define UIColor_Gray_Text           UIColorFromRGB(0xa9a9a9)
#define UIColor_DarkGray_Text           UIColorFromRGB(0x8f8f8f)
#define UIColor_XiaoDaiCellGray_Text           UIColorFromRGB(0x979797)
#define UIColor_RedButtonBGNormal           UIColorFromRGB(0xf96969)
#define UIColor_RedButtonBGHighLight           UIColorFromRGB(0xff5e5e)
#define UIColor_LightBlueButtonBGNormal           UIColorFromRGB(0x19cbeb)
#define UIColor_LightBlueButtonBGHighLight           UIColorFromRGB(0x18d2f4)
#define UIColor_Black_Text           UIColorFromRGB(0x455a64)
#define UIColor_BlueBorderBtn_Normal           UIColorFromRGB(0x448aff)
#define UIColor_BlueBorderBtn_HighLight           UIColorFromRGB(0x246acf)


//灰色分割线
#define UIColor_GrayLine           UIColorFromRGB(0xd1d1d1)

//特殊字符
#define SpecialCharacters     @"\\[]{}#%^*+=\"|~<>.,?!'/:;()$&@€£¥_-• "
//数字
#define NUM @"0123456789"
//数字和小数点
#define NumAndDecimal @"0123456789."

//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//应用程序版本号
#define APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
//ios系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//空字符处理
#define HLStringNotNull(stringValue) [NSString stringWithFormat:@"%@",([stringValue isEqual:[NSNull null]] ? @"" : stringValue)]



//KeyChainGroupName钥匙串分组
//企业证书发布
#define kKeyChainAccessGroup_Gesture [NSString stringWithUTF8String:"9KWBX68VRJ.com.Boen.Gesture"]
#define kKeyChainAccessGroup_LastLoginUserId [NSString stringWithUTF8String:"9KWBX68VRJ.com.Boen.LastLoginUserId"]
//AppStore发布
//#define kKeyChainAccessGroup_Gesture [NSString stringWithUTF8String:"KSSXQ4T7NW.com.Boen.Gesture"]
//#define kKeyChainAccessGroup_LastLoginUserId [NSString stringWithUTF8String:"KSSXQ4T7NW.com.Boen.LastLoginUserId"]

#define kRequestReturnData  @"data"   //返回的数据
#define kRequestMessage     @"msg"    //返回的消息
#define kRequestRetCode     @"result_code"//返回的错误码
#define kRequestRetMessage  @"result_message" //返回的错误消息


#define kRequestSuccessCode @"0000" //请求处理成功的返回码


#define kGlobalLoginStatus  @"GlobalLoginStatus"

#define kRechargeOneCardSolutionNo    @"OneCardSolutionNo"
#define kRechargeProjectName          @"ProjectName"
#define kRechargeAmountOfMoney        @"AmountOfMoney"
#define kRechargeDisplayOfMoney       @"DisplayOfMoney"
#define kMobileRechargebndk_amount    @"bndk_amount"
#define kMobileRechargesp_amount      @"sp_amount"
#define kMobileRechargepid            @"pid"
#define kMobileFlowRecharge           @"FlowRecharge"
#define kNoticeMobilePhone            @"NoticeMobilePhone"
#define kNetworkErrorMsg              @"网络错误，请稍后再试"
#define kHomeLoadingMsg               @"获取数据中，请稍候..."
#define kNetworkErrorMsgWhenPay       @"当前网络异常，无法确认交易状态，请稍后到“订单中心”查看此笔交易是否成功"

//通知名
#define kNotificationCenter    [NSNotificationCenter defaultCenter]

#define kNotification_SelectedVillage                  @"kNotification_SelectedVillage"
#define kNotification_SelectedRentFees                 @"kNotification_SelectedRentFees"
#define kNotification_SelectedHouse                    @"kNotification_SelectedHouse"

#define kNotification_getProfileFinish                  @"kNotification_getProfileFinish"
#define kNotification_chargeFinish                      @"kNotification_chargeFinish"
#define kNotification_TableViewScroll                   @"kNotification_TableViewScroll"
#define kNotification_UpdateUserInfo                    @"kNotification_UpdateUserInfo"
#define kNotification_UpdateCurrentPageData            @"kNotification_UpdateCurrentPageData"
//收到推送消息时，发送的通知
#define kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList                 @"kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList"
#define kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList                 @"kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList"

///消息中心数据请求完成
#define kNotification_Message_HadLoaded @"kNotification_Message_HadLoaded"

//NSUserdefault的关键字
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kBundleKey @"CFBundleShortVersionString"  //版本

#define kHasShowedActivityView @"kHasShowedActivityView"

#define kHasShowPaySchoolFeesExplain @"PaySchoolFeesExplainIsShow"

#define kHasSavedLivenessDetectionImages @"kHasSavedLivenessDetectionImages"

#define kScanToPayIntroHadRead @"kScanToPayIntroHadRead"


#define kSectionHeight [BNTools sizeFit:10 six:14 sixPlus:18]

#define kBankCardListCellHeight 63*BILI_WIDTH

#define kISOpenTouchIDKEY @"kISOpenTouchIDKEY"

#define kBannerCache @"BannerCache"

#define kSchoolFessCode @"SchoolFessCode"
#define kUserAvatarKey @"kUserAvatarKey"

#define kUserIdKey @"kUserIdKey"

#define kKeyChainIdentifier    @"kKeyChainIdentifier"
#define kKeyChainGroup         @"kKeyChainGroup"
#define kLast_login_account    @"kLast_login_account" //上次登录的账号
#define kLast_userId           @"kLast_userId" //上次登录的userId

#define kVersionKey            @"kVersionKey"  //版本号

#endif
