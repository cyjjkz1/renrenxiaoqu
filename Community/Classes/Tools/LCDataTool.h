//
//  LCDataTool.h
//  Community
//
//  Created by mac1 on 16/7/25.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "RentInfoModel.h"

@interface LCDataTool : NSObject


// 返回第page页的收藏:page从1开始, 默认每页显示20条
+ (NSArray *)collectInfo:(int)page;

//收藏信息条数
+ (int)collectInfosCount;

//添加一条收藏
+ (void)addInfo:(RentInfoModel *)infoModel;

//移除一套收藏
+ (void)removeCollect:(RentInfoModel *)infoModel;

//是否收藏了此信息
+ (BOOL)isCollect:(RentInfoModel *)infoModel;

@end
