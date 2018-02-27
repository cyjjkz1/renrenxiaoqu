//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "QSWXApiManager.h"

NSString *const   WX_APP_ID = @"wx097d7911a342e500";
NSString *const   WX_APP_SECRET = @"ba83a3d1fd76b93aa928a620ebcab0e5";
NSString *const   kWeiXinPayResultNotification = @"kWeiXinPayResultNotification";
NSString *const   kWeiXinPaySuccessNotification = @"kWeiXinPaySuccessNotification";
NSString *const   kWeiXinPayFailedNotification = @"kWeiXinPayFailedNotification";
NSString *const   kPayCenterDismissNotification = @"kPayCenterDismissNotification";
@implementation QSWXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static QSWXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QSWXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//
//            default:
//                strMsg = @"支付结果：失败";
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
        [self requestWeiXinPayResult];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayResultNotification object:nil];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }

}

- (void)requestWeiXinPayResult{
    [SVProgressHUD showWithStatus:@"正常查询支付结果..."];
    [RequestApi checkWeiXinResult:self.orderNumber
                          success:^(NSDictionary *successData) {
                              [SVProgressHUD dismiss];
                              if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                  [[[UIAlertView alloc] initWithTitle:@"提示" message:@"交费成功" delegate:nil
                                                    cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                              }else{
                                  [[[UIAlertView alloc] initWithTitle:@"提示" message:@"交费失败" delegate:nil
                                                    cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                              }
                              [[NSNotificationCenter defaultCenter] postNotificationName:kPayCenterDismissNotification object:nil];
                          } failed:^(NSError *error) {
                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                          }];
}
- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
