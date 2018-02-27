//
//  HttpTools.m
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import "HttpTools.h"
#import "NSString+MD5.h"

@implementation HttpTools
static AFHTTPSessionManager *manager;
static HttpTools *httpTools;

static NSString *content;

//GCD单例
+(HttpTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[HttpTools alloc]init];
        content = [[NSString alloc]
                    initWithFormat:
                    @"localized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@ \napp version: %@" ,
                    
                    [[UIDevice currentDevice] localizedModel],
                    [[UIDevice currentDevice] systemVersion],
                    [[UIDevice currentDevice] systemName],
                    [[UIDevice currentDevice] model],
                    [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey]
                    ];
    });
    return httpTools;
}

//GCD单例
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [super allocWithZone:zone];
        [self initManager];
    });
    return httpTools;
}

+(void)initManager
{
    NSURL *url = [NSURL URLWithString:BASE_URL];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 60;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil];
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
//    manager.securityPolicy = securityPolicy;
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
}

- (void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured
{
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [manager GET:url parameters:infoParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successed(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failured(task,error);
    }];
}

- (void)JsonPostRequst:(NSString *)url
             signArray:(NSArray *)signArray
            parameters:(NSDictionary *)parameters
               success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured
{
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray *sortArr = [signArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *sign = [self sign_md5:sortArr];
    
    [infoParameters setObject:sign.lowercaseString forKey:@"sign"];
    
    NSLog(@"BASE_URL --- %@",BASE_URL);
    [manager POST:url parameters:infoParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successed(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failured(task,error);
    }];
}


//重写了一套加密方法--->>>>>>
- (NSString *)signParameterWithDic:(NSDictionary *)dic
{
    NSArray *encodeArr = [self encodeParametersDic:dic sort:YES];
    NSString *signStr = [self sign_md5:encodeArr];
    
    NSLog(@"lc____sign____ %@",signStr);
    
    return signStr;
}

- (NSArray *)encodeParametersDic:(NSDictionary *)dic sort:(BOOL)sort
{
    NSMutableArray *arr = @[].mutableCopy;
    NSArray *allKeys = [dic allKeys];
    for (int i = 0; i < allKeys.count; i ++) {
        NSString *aKey = allKeys[i];
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",aKey, [dic valueForKey:aKey]];
        [arr addObject:keyValueStr];
    }
    if (sort) {
        return [arr sortedArrayUsingSelector:@selector(compare:)];
    }
    return arr;
}

//重写了一套加密方法<<<<<<-------

- (NSString *)sign_md5:(NSArray *)arr
{
    NSString *str = @"";
    for(int i = 0; i < arr.count; i ++){
        str = [str stringByAppendingString:arr[i]];
    }
    
    str = [str stringByAppendingString:SIGN_STR];
    NSLog(@"sign_before---->>>%@",str);
    
    NSString *signStr = [str MD5Digest];
    
    NSLog(@"sign_after---->>>>%@",signStr);
    return signStr;

}

@end
