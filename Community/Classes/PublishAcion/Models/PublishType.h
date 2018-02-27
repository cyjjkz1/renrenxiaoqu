//
//  PublishType.h
//  Community
//
//  Created by mac1 on 16/9/7.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishType : NSObject

@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *sortNo;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *remark;


+ (PublishType *)changeDicToType:(NSDictionary *)dic;



@end
