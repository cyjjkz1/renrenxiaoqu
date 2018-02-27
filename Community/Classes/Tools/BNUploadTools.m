//
//  BNUploadTools.m
//  Wallet
//
//  Created by mac1 on 15/5/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNUploadTools.h"
#import "HttpTools.h"
#import "NSString+MD5.h"

@implementation BNUploadTools

#define kUploadAvatar_URL     @"/app/personal/uploadHeadPortrait.do"

static AFHTTPSessionManager *manager;
static BNUploadTools *uploadTools;

static NSString *content;

//GCD单例
+(BNUploadTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadTools = [[BNUploadTools alloc]init];
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
    return uploadTools;
}

//GCD单例
-(id)init
{
    self = [super init];
    if (self) {
        content = [[NSString alloc]
                   initWithFormat:
                   @"localized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@ \napp version: %@" ,
                   
                   [[UIDevice currentDevice] localizedModel],
                   [[UIDevice currentDevice] systemVersion],
                   [[UIDevice currentDevice] systemName],
                   [[UIDevice currentDevice] model],
                   [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey]
                   ];
        
        [self initManager];
    }
    
    return self;
}


- (void)initManager{
//    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
    
}

//个人中心上传头像
- (void)uploadUserAvatarWithData:(NSData *)data
                         success:(void(^)(id responseObject)) successed
                        progress:(void(^)(NSProgress *uploadProgress))progress
                         failure:(void(^)(NSError *error)) failured
{
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kUploadAvatar_URL];
//    url = @"http://192.168.0.110:8089/app/personal/uploadHeadPortrait.do";
//    NSError *error = nil;
    NSString *userId = [UserInfo sharedUserInfo].userId;
    NSDictionary *params = @{@"userID": userId};
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        
        
        //上传的参数(上传图片，以文件流的格式)
        
        [formData appendPartWithFileData:data
                                    name:@"headPorFile"
                                fileName:fileName
                                mimeType:@"image/png"];
        
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        successed(responseObject);
        //上传成功
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {        
        //上传失败
        failured(error);
    }];
    
    
    
    
//    NSArray *signArr = @[[NSString stringWithFormat:@"userID=%@",userId]];
//    NSArray *sortArr = [signArr sortedArrayUsingSelector:@selector(compare:)];
//    NSString *sign = [self sign_md5:sortArr];
    
//    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:params];
//    [infoParameters setObject:sign.lowercaseString forKey:@"sign"];
    /*
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:url
                                                                   parameters:params
                                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        [formData appendPartWithFileData:data
                                                                    name:@"headPorFile"
                                                                fileName:@"usr_avatar_file.png"
                                                                mimeType:@"image/png"];
                                        
                                    } error:&error];
    
    
    
    
    
    NSURLSessionUploadTask *uploadTask =  [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"-----%@",responseObject);
        
        if (error) {
            failured(error);
        }else{
            successed(responseObject);
        }
        
    }];
    
    [uploadTask resume];
     
     */
    
}

- (void)uploadImageWithData:(NSData *)data
                    success:(void(^)(id responseObject)) successed
                   progress:(void(^)(NSProgress *uploadProgress))progress
                    failure:(void(^)(NSError *error)) failured
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kUploadAvatar_URL];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data
                                    name:@"headPorFile"
                                fileName:fileName
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {

        progress(uploadProgress);
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        successed(responseObject);

    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        failured(error);
    }];

}

//- (NSString *)sign_md5:(NSArray *)arr
//{
//    NSString *str = @"";
//    for(int i = 0; i < arr.count; i ++){
//        str = [str stringByAppendingString:arr[i]];
//    }
//    
//    str = [str stringByAppendingString:SIGN_STR];
//    NSLog(@"sign_before---->>>%@",str);
//    
//    NSString *signStr = [str MD5Digest];
//    
//    NSLog(@"sign_after---->>>>%@",signStr);
//    return signStr;
//    
//}

@end
