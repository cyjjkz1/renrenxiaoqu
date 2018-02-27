//
//  RequestApi.h
//  Community
//
//  Created by mac1 on 16/8/22.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestApi : NSObject

//微信查询接口
+ (void)checkWeiXinResult:(NSString *) orderNumber
                  success:(void (^)(NSDictionary *successData))successMethod
                   failed:(void (^)(NSError *error))errorMethod;
//支付宝查询接口
+ (void)checkAlipayResult:(NSString *) orderNumber
                  success:(void (^)(NSDictionary *successData))successMethod
                   failed:(void (^)(NSError *error))errorMethod;

//sos接口
+ (void)sosToWuYeWithPhone:(NSString *)phone
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod;

//1、登录接口
+ (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
                success:(void (^)(NSDictionary *successData))successMethod
                 failed:(void (^)(NSError *error))errorMethod;

//2、注册 手机号（mobile），密码（password），业主类型（type）
+ (void)registWithMobile:(NSString *)mobile
                password:(NSString *)password
                    type:(NSString *)type
            buildingName:(NSString *)buildingName
                roomName:(NSString *)roomName
                 success:(void (^)(NSDictionary *successData))successMethod
                  failed:(void (^)(NSError *error))errorMethod;

//3、忘记密码  用户编号（id），原密码（password），新密码（repassword）
+ (void)forget_passwordWithUserNum:(NSString *)userNum
                            oldPws:(NSString *)oldPwd
                            newPwd:(NSString *)newPwd
                           success:(void (^)(NSDictionary *successData))successMethod
                            failed:(void (^)(NSError *error))errorMethod;
//4、获取轮播图
+ (void)getBannerDataSuccess:(void (^)(NSDictionary *successData))successMethod
                      failed:(void (^)(NSError *error))errorMethod;

//5、求租求购消息发布类型  用户编号（id）
+ (void)askTypeWithUserNum:(NSString *)userNum
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod;

//6、车位/房屋出租求租求购 文章编号（articleID）
+ (void)askHouseWithArticleID:(NSString *)articleID
                      success:(void (^)(NSDictionary *successData))successMethod
                       failed:(void (^)(NSError *error))errorMethod;


//7、车位/房屋出售 文章编号（articleID）
+ (void)saleHouseWithArticleID:(NSString *)articleID
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod;

//8、创建求租求购信息
+ (void)createRentAndBuyInfoWithUserId:(NSString *)userId
                             houseType:(NSString *)houseType
                             direction:(NSString *)direction
                               payType:(NSString *)payType
                           consultType:(NSString *)consultType
                        decorationType:(NSString *)decorationType
                                 title:(NSString *)title
                           articleType:(NSString *)articleType
                             titleType:(NSString *)titleType
                                 price:(NSString *)price
                                  desp:(NSString *)desp
                               address:(NSString *)address
                                 files:(NSString *)files
                               photoId:(NSString *)photoId
                               success:(void (^)(NSDictionary *successData))successMethod
                                failed:(void (^)(NSError *error))errorMethod;;

//信息列表
+ (void)getInfoListWithArticleType:(NSString *)articleType
                         titleType:(NSString *)titleType
                            userId:(NSString *)userId
                             index:(NSString *)index
                              size:(NSString *)size
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod;


//获取用户信息 getProfile
+ (void)getUserInfoWithUserId:(NSString *)userId
                      success:(void (^)(NSDictionary *successData))successMethod
                       failed:(void (^)(NSError *error))errorMethod;

//修改个人信息用户编号（id），姓（lastName），名（firstName），性别（gender：0.女，1.男），所在小区（buildingName)，手机号（mobile），密码（password）
+ (void)modifyUserInfoWithUserId:(NSString *)userId
                            name:(NSString *)name
                          gender:(NSString *)gender
                    buildingName:(NSString *)buildingName
                          status:(NSString *)status
                        password:(NSString *)password
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

//查询租户 用户编号（id）
+ (void)searchLesseesWithUserId:(NSString *)userId
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;

//添加租户 用户编号（id），租户手机号（mobile）
+ (void)createLesseesWithUserId:(NSString *)userId
                   renterMobile:(NSString *)number
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;

//业主解除关系 用户编号（id）
+ (void)relieveRelationShipByMasterWithUserId:(NSString *)userId
                                 renterMobile:(NSString *)mobile
                                      success:(void (^)(NSDictionary *successData))successMethod
                                       failed:(void (^)(NSError *error))errorMethod;


//租户解除关系
+ (void)relieveRelationShipByLesseerWithUserId:(NSString *)userId
                                      success:(void (^)(NSDictionary *successData))successMethod
                                       failed:(void (^)(NSError *error))errorMethod;

//水电 用户编号（id）
+ (void)get_electricalAndWaterInfoWithUserId:(NSString *)userId
                                     success:(void (^)(NSDictionary *successData))successMethod
                                      failed:(void (^)(NSError *error))errorMethod;

//
+ (void)get_wuYeFeesWithUserId:(NSString *)userId
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod;

//用户消息 用户编号（id），分页：第几页（index），每页几条（size）
+ (void)requestUserMsgWithUserId:(NSString *)userId
                           index:(NSString *)index
                         andSize:(NSString *)size
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

//消息详情 消息编号(msgID)
+ (void)msgDetailWithMsgId:(NSString *)msgId
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod;

// 修改发布文章状态
+ (void)modifyInfoSatatusWithId:(NSString *)articleId
                         status:(NSString *)status
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;
// 校验原密码
+ (void)checkOriginPasswordWithUserId:(NSString *)userId
                             password:(NSString *)password
                              success:(void (^)(NSDictionary *successData))successMethod
                               failed:(void (^)(NSError *error))errorMethod;

//获取支付信息
+ (void)requestPayInfoWithPrice:(NSString *)price
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;
//修改密码
+ (void)modifyUserPasswordWithId:(NSString *)userId
                          newPsw:(NSString *)repassword
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

//获取orderString
+ (void)getOrderStringWithUserId:(NSString *)userId
                         goodsId:(NSString *)goodsId
                         payType:(NSString *)payType
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

+ (void)paybackWithout_trade_no:(NSString *)outTradeNo
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;

+ (void)sendSmsRegWithMobile:(NSString *)mobile
                     success:(void (^)(NSDictionary *successData))successMethod
                      failed:(void (^)(NSError *error))errorMethod;

+ (void)sendSmsForgetWithMobile:(NSString *)mobile
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;


+ (void)checkValidCodeWithMobile:(NSString *)mobile
                            code:(NSString *)code
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

+ (void)getBuildingInfoSuccess:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod;

+ (void)getRoomsWithbuildingName:(NSString *)buildingName
                         Success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;

+ (void)modifyAddressWithUserId:(NSString *)userId
                   buildingName:(NSString *)buildingName
                       roomName:(NSString *)roomName
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod;

+ (void)weixinPrecreateOrderWithUserId:(NSString *)userId
                               goodsID:(NSString *)goodsID
                               payType:(NSString *)payType
                               success:(void (^)(NSDictionary *successData))successMethod
                                failed:(void (^)(NSError *error))errorMethod;

@end
