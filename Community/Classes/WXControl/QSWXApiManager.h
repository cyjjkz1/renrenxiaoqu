//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//微信
FOUNDATION_EXPORT NSString *const   WX_APP_ID;
FOUNDATION_EXPORT NSString *const   WX_APP_SECRET;
FOUNDATION_EXPORT NSString *const   kWeiXinPayResultNotification;
FOUNDATION_EXPORT NSString *const   kWeiXinPaySuccessNotification;
FOUNDATION_EXPORT NSString *const   kWeiXinPayFailedNotification;
FOUNDATION_EXPORT NSString *const   kPayCenterDismissNotification;
@protocol QSWXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface QSWXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<QSWXApiManagerDelegate> delegate;
@property (nonatomic, copy) NSString *orderNumber;
+ (instancetype)sharedManager;

@end
