//
//  BNUploadTools.h
//  Wallet
//
//  Created by mac1 on 15/5/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
//文件类型
typedef NS_ENUM(NSInteger, UploadFileType) {
    UploadFileTypeImage,         //照片
    UploadFileTypeVedio,         //视频
};
@interface BNUploadTools : NSObject

+(BNUploadTools *)shareInstance;

// 个人中心上传头像
- (void)uploadUserAvatarWithData:(NSData *)data
                         success:(void(^)(id responseObject)) successed
                        progress:(void(^)(NSProgress *uploadProgress))progress
                         failure:(void(^)(NSError *error)) failured;


// 上传图片
- (void)uploadImageWithData:(NSData *)data
                    success:(void(^)(id responseObject)) successed
                   progress:(void(^)(NSProgress *uploadProgress))progress
                    failure:(void(^)(NSError *error)) failured;


@end
