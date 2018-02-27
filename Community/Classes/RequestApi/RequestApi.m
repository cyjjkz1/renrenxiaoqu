//
//  RequestApi.m
//  Community
//
//  Created by mac1 on 16/8/22.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RequestApi.h"
#import "HttpTools.h"

@implementation RequestApi

static HttpTools *tool;

//#ifdef COMMUNITY_HTTP
//登录
NSString *const login = @"/app/login/begin_login.do";
//注册
NSString *const regist = @"/app/login/register.do";
//忘记密码
NSString *const forget_password = @"/app/login/forget_password.do";
//获取轮播图
NSString *const get_banner = @"/app/home_page/activity_banner.do";
//获取发布类型
NSString *const articleType = @"/app/rental/articleTypes.do";
//车位/房屋出租求租求购
NSString *const ask_house = @"/app/rental/rentArticleEdit.do";
//车位/房屋出售
NSString *const sale_house = @"/app/rental/saleArticleEdit.do";
//创建求租求购信息
NSString *const create_rentInfo = @"/app/rental/createRentAndBuyInfo.do";
//信息列表
NSString *const info_list = @"/app/rental/articleList.do";
//获取用户信息
NSString *const get_userInfo = @"/app/personal/getUserInfo.do";
//修改个人信息
NSString *const modify_userInfo = @"/app/personal/modifyPersonalInfo.do";
//查询租户
NSString *const searchLessees = @"/app/personal/searchLessees.do";
//添加租户
NSString *const createLessees = @"/app/personal/createLessees.do";
//业主解除关系
NSString *const relieveRelationShipByMaster = @"/app/personal/relieveRelationShipByMaster.do";
//租户解除关系
NSString *const relieveRelationShipByLessee = @"/app/personal/relieveRelationShipByLessee.do";
//水电
NSString *const electricalAndWaterInfo = @"/app/home_page/electricalAndWaterInfo.do";
//用户消息
NSString *const userMsg = @"/app/personal/userMsg.do";
//消息详情
NSString *const messageDetail = @"/app/personal/messageDetail.do";
//修改发布文章状态
NSString *const modifyInfoStatus = @"/app/personal/modifyArticleStatus.do";
//校验原密码
NSString *const checkPassword = @"/app/login/checkPassword.do";
//支付信息获取
NSString *const appToAppAuth = @"/app/alipay/appToAppAuth.do";

//支付回调
NSString *const propertyFee = @"/app/alipay/modifyPayOrderStatus.do";

//修改密码
NSString *const modifyPsw = @"/app/login/modifyPassword.do";

NSString *const getOrderStr = @"/app/alipay/createOrderString.do";

//物业费
NSString *const wuyeFees = @"/app/home_page/propertyFee.do";

//注册获取验证码
NSString *const sendSmsReg = @"/app/sms/sendSmsReg.do";

//忘记密码获取验证码
NSString *const sendSmsForget = @"/app/sms/sendSmsForget.do";

//校验验证码
NSString *const checkValidateCode = @"/app/sms/checkValidateCode.do";

//获取楼宇信息
NSString *const getBuildings = @"/app/login/getBuildings.do";

//注册获取房间号
NSString *const getRooms = @"/app/login/getRooms.do";


//微信支付
NSString *const weixinPrecreateOrder = @"/app/weixinPay/initWeixinPay.do";

//支付宝
NSString *const alipayPrecreateOrder = @"/app/alipay/initAlipay.do";

//微信查询结果
NSString *const alipayCheckResult  = @"/app/alipay/filchPayResult.do";

//支付宝查询结果
NSString *const weixinCheckResult = @"/app/weixinPay/filchPayResult.do";
//sos接口
NSString *const sosToWuYe = @"/app/sms/sendSmsSOS.do";

/*
#else
NSString *const login = @"/app/login/begin_login.do";
NSString *const regist = @"/app/login/register.do";
NSString *const forget_password = @"/app/login/forget_password.do";
NSString *const get_banner = @"/app/home_page/activity_banner.do";
NSString *const articleType = @"/app/rental/articleTypes.do";
NSString *const ask_house = @"/app/rental/rentArticleEdit.do";
NSString *const sale_house = @"/app/rental/saleArticleEdit.do";
NSString *const create_rentInfo = @"/app/rental/createRentAndBuyInfo.do";
NSString *const info_list = @"/app/rental/articleList.do";
NSString *const get_userInfo = @"/app/personal/getUserInfo.do";
NSString *const modify_userInfo = @"/app/personal/modifyPersonalInfo.do";
NSString *const searchLessees = @"/app/personal/searchLessees.do";
NSString *const createLessees = @"/app/personal/createLessees.do";
NSString *const relieveRelationShipByMaster = @"/app/personal/relieveRelationShipByMaster.do";
NSString *const relieveRelationShipByLessee = @"/app/personal/relieveRelationShipByLessee.do";
NSString *const electricalAndWaterInfo = @"/app/home_page/electricalAndWaterInfo.do";
NSString *const userMsg = @"/app/personal/userMsg.do";
NSString *const messageDetail = @"/app/personal/messageDetail.do";
NSString *const modifyInfoStatus = @"/app/personal/modifyArticleStatus.do";
NSString *const checkPassword = @"/app/login/checkPassword.do";
NSString *const appToAppAuth = @"/app/alipay/appToAppAuth.do";
NSString *const modifyPsw = @"/app/login/modifyPassword.do";
NSString *const getOrderStr = @"/app/alipay/createOrderString.do";
NSString *const wuyeFees = @"/app/home_page/propertyFee.do";
NSString *const sendSmsReg = @"/app/sms/sendSmsReg.do";
NSString *const sendSmsForget = @"/app/sms/sendSmsForget.do";
NSString *const checkValidateCode = @"/app/sms/checkValidateCode.do";

#endif
*/

+ (void)initialize
{
    tool = [HttpTools shareInstance];
}
+ (void)checkWeiXinResult:(NSString *) orderNumber
                  success:(void (^)(NSDictionary *successData))successMethod
                   failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *params = @{@"orderNo": orderNumber};
    NSArray *signArr = @[[NSString stringWithFormat:@"orderNo=%@",orderNumber]];
    [tool JsonPostRequst:weixinCheckResult signArray:signArr parameters:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}
+ (void)checkAlipayResult:(NSString *) orderNumber
                  success:(void (^)(NSDictionary *successData))successMethod
                   failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *params = @{@"orderNo": orderNumber};
    NSArray *signArr = @[[NSString stringWithFormat:@"orderNo=%@",orderNumber]];
    [tool JsonPostRequst:alipayCheckResult signArray:signArr parameters:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
    
}

+ (void)sosToWuYeWithPhone:(NSString *)phone
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *params = @{@"mobile": phone};
    [tool JsonGetRequst:sosToWuYe parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
    
}
+ (void)weixinPrecreateOrderWithUserId:(NSString *)userId
                               goodsID:(NSString *)goodsID
                               payType:(NSString *)payType
                               success:(void (^)(NSDictionary *successData))successMethod
                                failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *params = @{@"userId": userId,
                            @"productId": goodsID,
                            @"orderType": payType
                            };
    NSArray *signArr = @[[NSString stringWithFormat:@"orderType=%@",payType],
                         [NSString stringWithFormat:@"productId=%@",goodsID],
                         [NSString stringWithFormat:@"userId=%@",userId]];
    
    [tool JsonPostRequst:weixinPrecreateOrder signArray:signArr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}
//登录
+ (void)loginWithMobile:(NSString *)mobile
         password:(NSString *)password
          success:(void (^)(NSDictionary *successData))successMethod
           failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"mobile":mobile,
                            @"password":password};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"mobile=%@",mobile],[NSString stringWithFormat:@"password=%@",password]];
    [tool JsonPostRequst:login signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//注册
+ (void)registWithMobile:(NSString *)mobile
                password:(NSString *)password
                    type:(NSString *)type
            buildingName:(NSString *)buildingName
                roomName:(NSString *)roomName
                 success:(void (^)(NSDictionary *successData))successMethod
                  failed:(void (^)(NSError *error))errorMethod;
{
    
    
    NSMutableDictionary *parms = @{@"mobile":mobile,
                                   @"password":password,
                                    @"type":type,
                            }.mutableCopy;
    NSMutableArray *signArr = @[[NSString stringWithFormat:@"mobile=%@",mobile],[NSString stringWithFormat:@"password=%@",password],[NSString stringWithFormat:@"type=%@",type]].mutableCopy;
    if (buildingName && buildingName.length > 0) {
        [parms setObject:buildingName forKey:@"buildingName"];
        [signArr addObject:[NSString stringWithFormat:@"buildingName=%@",buildingName]];
       
    }
    if (roomName && roomName.length > 0) {
        [parms setObject:roomName forKey:@"roomName"];
        [signArr addObject:[NSString stringWithFormat:@"roomName=%@",roomName]];
        
    }
    [tool JsonPostRequst:regist signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

//忘记密码
+ (void)forget_passwordWithUserNum:(NSString *)userNum
                            oldPws:(NSString *)oldPwd
                            newPwd:(NSString *)newPwd
                           success:(void (^)(NSDictionary *successData))successMethod
                            failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"userId":userNum,
                            @"passwrod":oldPwd,
                            @"repassword":newPwd};
    NSArray *signArr = @[[NSString stringWithFormat:@"userId=%@",userNum], [NSString stringWithFormat:@"passwrod=%@",oldPwd], [NSString stringWithFormat:@"repassword=%@",newPwd]];
    [tool JsonPostRequst:forget_password signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//获取轮播图
+ (void)getBannerDataSuccess:(void (^)(NSDictionary *successData))successMethod
                      failed:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:get_banner signArray:nil parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

//求租求购发布类型
+ (void)askTypeWithUserNum:(NSString *)userNum
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userNum};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userNum]];
    [tool JsonPostRequst:articleType signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//车位/房屋出租求租求购 文章编号（articleID）
+ (void)askHouseWithArticleID:(NSString *)articleID
                      success:(void (^)(NSDictionary *successData))successMethod
                       failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"articleID":articleID};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"articleID=%@",articleID]];
    [tool JsonPostRequst:ask_house signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}


//车位/房屋出售 文章编号（articleID）
+ (void)saleHouseWithArticleID:(NSString *)articleID
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"articleID":articleID};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"articleID=%@",articleID]];
    [tool JsonPostRequst:sale_house signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}


//获取用户信息
+ (void)getUserInfoWithUserId:(NSString *)userId
                      success:(void (^)(NSDictionary *successData))successMethod
                       failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userId};
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId]];
    [tool JsonPostRequst:get_userInfo signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

//修改个人信息用户编号
+ (void)modifyUserInfoWithUserId:(NSString *)userId
                            name:(NSString *)name
                          gender:(NSString *)gender
                    buildingName:(NSString *)buildingName
                          status:(NSString *)status
                        password:(NSString *)password
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;
{
    NSMutableDictionary *parms = @{@"id":userId}.mutableCopy;
    NSMutableArray *signArr = @[].mutableCopy;
    
    [signArr addObject:[NSString stringWithFormat:@"id=%@",userId]];
    
    if (name && name.length > 0) {
        
        [parms setObject:[name substringWithRange:NSMakeRange(0, 1)] forKey:@"firstName"];
        [signArr addObject:[NSString stringWithFormat:@"firstName=%@",[name substringWithRange:NSMakeRange(0, 1)]]];
        
        [parms setObject:[name substringWithRange:NSMakeRange(1, name.length - 1)] forKey:@"lastName"];
        [signArr addObject:[NSString stringWithFormat:@"lastName=%@",[name substringWithRange:NSMakeRange(1, name.length - 1)]]];
    }
    
    if (gender && gender.length > 0) {
        [parms setObject:gender forKey:@"gender"];
        [signArr addObject:[NSString stringWithFormat:@"gender=%@",gender]];
    }
    
    if (buildingName && buildingName.length > 0) {
        [parms setObject:buildingName forKey:@"buildingName"];
        [signArr addObject:[NSString stringWithFormat:@"buildingName=%@",buildingName]];
    }
    if (password && password.length > 0) {
        [parms setObject:password forKey:@"password"];
        [signArr addObject:[NSString stringWithFormat:@"password=%@",password]];
    }

    
    if (status && status.length > 0) {
        [parms setObject:status forKey:@"status"];
    }
    [tool JsonPostRequst:modify_userInfo signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         errorMethod(error);
    }];
    
}

//查询租户 用户编号（id）
+ (void)searchLesseesWithUserId:(NSString *)userId
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userId};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId]];
    [tool JsonPostRequst:searchLessees signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
    
}

//添加租户 用户编号（id），租户手机号（mobile）
+ (void)createLesseesWithUserId:(NSString *)userId
                   renterMobile:(NSString *)number
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userId,
                            @"mobile":number};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId],[NSString stringWithFormat:@"mobile=%@",number]];
    [tool JsonPostRequst:createLessees signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

//业主解除关系 用户编号（id）
+ (void)relieveRelationShipByMasterWithUserId:(NSString *)userId
                                 renterMobile:(NSString *)mobile
                                      success:(void (^)(NSDictionary *successData))successMethod
                                       failed:(void (^)(NSError *error))errorMethod;
{
    NSDictionary *parms = @{@"id":userId,@"mobile":mobile};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId], [NSString stringWithFormat:@"mobile=%@",mobile]];
    [tool JsonPostRequst:relieveRelationShipByMaster signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//租户解除关系
+ (void)relieveRelationShipByLesseerWithUserId:(NSString *)userId
                                       success:(void (^)(NSDictionary *successData))successMethod
                                        failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"userId":userId};
    NSArray *signArr = @[[NSString stringWithFormat:@"userId=%@",userId]];
    [tool JsonPostRequst:relieveRelationShipByLessee signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//水电 用户编号（id）
+ (void)get_electricalAndWaterInfoWithUserId:(NSString *)userId
                                     success:(void (^)(NSDictionary *successData))successMethod
                                      failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userId};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId]];
    [tool JsonPostRequst:electricalAndWaterInfo signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}


//获取物业费
+ (void)get_wuYeFeesWithUserId:(NSString *)userId
                       success:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"userId":userId};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"userId=%@",userId]];
    [tool JsonPostRequst:wuyeFees signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//用户消息 用户编号（id），分页：第几页（index），每页几条（size）
+ (void)requestUserMsgWithUserId:(NSString *)userId
                           index:(NSString *)index
                         andSize:(NSString *)size
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"id":userId,
                            @"index":index,
                            @"size":size};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId], [NSString stringWithFormat:@"index=%@",index], [NSString stringWithFormat:@"size=%@",size]];
    [tool JsonPostRequst:userMsg signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//消息详情 消息编号(msgID)
+ (void)msgDetailWithMsgId:(NSString *)msgId
                   success:(void (^)(NSDictionary *successData))successMethod
                    failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parms = @{@"msgID":msgId};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"msgID=%@",msgId]];
    [tool JsonPostRequst:messageDetail signArray:signArr parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

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
                                failed:(void (^)(NSError *error))errorMethod;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *signArr = [NSMutableArray array];
    if (userId.length >0) {
        [params setObject:userId forKey:@"userId"];
        [signArr addObject:[NSString stringWithFormat:@"userId=%@",userId]];
    }
    if (houseType.length > 0) {
        [params setObject:houseType forKey:@"houseType"];
        [signArr addObject:[NSString stringWithFormat:@"houseType=%@",houseType]];
    }
    if (direction.length > 0) {
        [params setObject:direction forKey:@"direction"];
        [signArr addObject:[NSString stringWithFormat:@"direction=%@",direction]];
    }
    if (payType.length > 0) {
        [params setObject:payType forKey:@"payType"];
        [signArr addObject:[NSString stringWithFormat:@"payType=%@",payType]];
    }
    if (consultType.length > 0) {
        [params setObject:consultType forKey:@"consultType"];
        [signArr addObject:[NSString stringWithFormat:@"consultType=%@",consultType]];
    }
    if (decorationType.length > 0) {
        [params setObject:decorationType forKey:@"decorationType"];
        [signArr addObject:[NSString stringWithFormat:@"decorationType=%@",decorationType]];
    }
    if (title.length > 0) {
        [params setObject:title forKey:@"title"];
        [signArr addObject:[NSString stringWithFormat:@"title=%@",title]];
    }
    
    if (articleType.length > 0) {
        [params setObject:articleType forKey:@"articleType"];
        [signArr addObject:[NSString stringWithFormat:@"articleType=%@",articleType]];
    }
    if (titleType.length > 0) {
        [params setObject:titleType forKey:@"titleType"];
        [signArr addObject:[NSString stringWithFormat:@"titleType=%@",titleType]];
    }
    
    if (price.length > 0) {
        [params setObject:price forKey:@"price"];
        [signArr addObject:[NSString stringWithFormat:@"price=%@",price]];
    }
    if (desp.length > 0) {
        [params setObject:desp forKey:@"desp"];
        [signArr addObject:[NSString stringWithFormat:@"desp=%@",desp]];
    }
    
    if (address.length > 0) {
        [params setObject:address forKey:@"address"];
        [signArr addObject:[NSString stringWithFormat:@"address=%@",address]];
    }
    if (files.length > 0) {
        [params setObject:files forKey:@"files"];
        [signArr addObject:[NSString stringWithFormat:@"files=%@",files]];
    }
    if (photoId.length > 0) {
        [params setObject:photoId forKey:@"photoId"];
        [signArr addObject:[NSString stringWithFormat:@"photoId=%@",photoId]];

    }
    
    [tool JsonPostRequst:create_rentInfo signArray:signArr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

+ (void)getInfoListWithArticleType:(NSString *)articleType
                         titleType:(NSString *)titleType
                            userId:(NSString *)userId
                             index:(NSString *)index
                              size:(NSString *)size
                           success:(void (^)(NSDictionary *successData))successMethod
                            failed:(void (^)(NSError *error))errorMethod
{
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableArray *signArr = @[].mutableCopy;
    if (articleType.length > 0) {
        [params setObject:articleType forKey:@"articleType"];
        [signArr addObject:[NSString stringWithFormat:@"articleType=%@",articleType]];
    }
    
    if (titleType.length > 0) {
        [params setObject:titleType forKey:@"titleType"];
        [signArr addObject:[NSString stringWithFormat:@"titleType=%@",titleType]];
    }
    if (userId.length > 0) {
        [params setObject:userId forKey:@"userId"];
        [signArr addObject:[NSString stringWithFormat:@"userId=%@",userId]];
    }
    if (index.length > 0) {
        [params setObject:index forKey:@"index"];
        [signArr addObject:[NSString stringWithFormat:@"index=%@",index]];
    }
    
    if (size.length > 0) {
        [params setObject:size forKey:@"size"];
        [signArr addObject:[NSString stringWithFormat:@"size=%@",size]];
    }
    
    [tool JsonPostRequst:info_list signArray:signArr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

// 修改发布文章状态
+ (void)modifyInfoSatatusWithId:(NSString *)articleId
                         status:(NSString *)status
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *params = @{
                             @"id":articleId,
                             @"status":status
                             };
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",articleId],[NSString stringWithFormat:@"status=%@",status]];
    [tool JsonPostRequst:modifyInfoStatus signArray:signArr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
         successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

// 校验原密码
+ (void)checkOriginPasswordWithUserId:(NSString *)userId
                             password:(NSString *)password
                              success:(void (^)(NSDictionary *successData))successMethod
                               failed:(void (^)(NSError *error))errorMethod
{
    
    NSDictionary *params = @{
                             @"id":userId,
                             @"password":password
                             };
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId],[NSString stringWithFormat:@"password=%@",password]];
    [tool JsonPostRequst:checkPassword signArray:signArr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

+ (void)requestPayInfoWithPrice:(NSString *)price
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"price":price};
    NSArray *signArr = @[[NSString stringWithFormat:@"price=%@",price]];
    [tool JsonPostRequst:appToAppAuth signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

+ (void)modifyUserPasswordWithId:(NSString *)userId
                          newPsw:(NSString *)repassword
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"id":userId, @"repassword":repassword};
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId],[NSString stringWithFormat:@"repassword=%@",repassword]];
    [tool JsonPostRequst:modifyPsw signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}
+ (void)getOrderStringWithUserId:(NSString *)userId
                         goodsId:(NSString *)goodsId
                         payType:(NSString *)payType
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"userId":userId, @"productId":goodsId, @"orderType":payType};
    
    NSArray *signArr = @[[NSString stringWithFormat:@"userId=%@",userId],
                         [NSString stringWithFormat:@"productId=%@",goodsId],
                         [NSString stringWithFormat:@"orderType=%@",payType]];
    
    [tool JsonPostRequst:alipayPrecreateOrder signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

+ (void)paybackWithout_trade_no:(NSString *)outTradeNo
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"outTradeNo":outTradeNo};
    NSArray *signArr = @[[NSString stringWithFormat:@"outTradeNo=%@",outTradeNo]];
    [tool JsonPostRequst:propertyFee signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}


+ (void)sendSmsRegWithMobile:(NSString *)mobile
                     success:(void (^)(NSDictionary *successData))successMethod
                      failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"mobile":mobile};
    NSArray *signArr = @[[NSString stringWithFormat:@"mobile=%@",mobile]];
    [tool JsonPostRequst:sendSmsReg signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

+ (void)sendSmsForgetWithMobile:(NSString *)mobile
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"mobile":mobile};
    NSArray *signArr = @[[NSString stringWithFormat:@"mobile=%@",mobile]];
    [tool JsonPostRequst:sendSmsForget signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}


+ (void)checkValidCodeWithMobile:(NSString *)mobile
                            code:(NSString *)code
                         success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod;
{
    NSDictionary *dic = @{@"mobile":mobile,@"code":code};
    NSArray *signArr = @[[NSString stringWithFormat:@"mobile=%@",mobile], [NSString stringWithFormat:@"code=%@",code]];
    [tool JsonPostRequst:checkValidateCode signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//获取楼宇信息
+ (void)getBuildingInfoSuccess:(void (^)(NSDictionary *successData))successMethod
                        failed:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:getBuildings signArray:nil parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];
}

//注册获取房间号
+ (void)getRoomsWithbuildingName:(NSString *)buildingName
                         Success:(void (^)(NSDictionary *successData))successMethod
                          failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"buildingName":buildingName};
    NSArray *signArr = @[[NSString stringWithFormat:@"buildingName=%@",buildingName]];
    [tool JsonPostRequst:getRooms signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

+ (void)modifyAddressWithUserId:(NSString *)userId
                   buildingName:(NSString *)buildingName
                       roomName:(NSString *)roomName
                        success:(void (^)(NSDictionary *successData))successMethod
                         failed:(void (^)(NSError *error))errorMethod
{
    NSDictionary *dic = @{@"id":userId,@"buildingName":buildingName,@"roomName":roomName};
    NSArray *signArr = @[[NSString stringWithFormat:@"id=%@",userId],[NSString stringWithFormat:@"buildingName=%@",buildingName],[NSString stringWithFormat:@"roomName=%@",roomName]];
    [tool JsonPostRequst:modify_userInfo signArray:signArr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(error);
    }];

}

@end
