//
//  HttpTools.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//https 发布环境
#define BASE_URL          @"http://wx.sqguanjia.com"

//http环境
//#define BASE_URL          @"http://wx.sqguanjia.com"

////测试环境 东花主机
//#define BASE_URL            @"http://192.168.0.91:8080"


#ifdef COMMUNITY_HTTP

//#define BASE_URL          @"https://wx.sqguanjia.com"

#else

//#define BASE_URL            @"http://192.168.0.110:8089"

#endif


#define SIGN_STR            @"COMMUNITYSERVICEVERSION101"


@interface HttpTools : NSObject

//http请求单例
+(HttpTools *)shareInstance;

/*
// headers
-(void)JsonGetRequst:(NSString *)url
          parameters:(NSDictionary *)parameters
             headers:(NSDictionary *)headers
             success:(void(^)(id responseObject))successed
             failure:(void(^)(NSError *error))failured;
*/

- (void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured;



- (void)JsonPostRequst:(NSString *)url
             signArray:(NSArray *)signArray
            parameters:(NSDictionary *)parameters
               success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured;

@end
