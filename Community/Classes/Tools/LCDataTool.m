//
//  LCDataTool.m
//  Community
//
//  Created by mac1 on 16/7/25.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "LCDataTool.h"

@implementation LCDataTool

static FMDatabase *_db;

+ (void)initialize
{ // 1.打开数据库
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [document stringByAppendingPathComponent:@"info.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_info(id integer PRIMARY KEY, info blob NOT NULL, info_id text NOT NULL);"];
}


+ (NSArray *)collectInfo:(int)page;
{
    int size = 10;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_info ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *infos = [NSMutableArray array];
    while (set.next) {
        RentInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"info"]];
        [infos addObject:info];
    }
    return infos;
}



+ (int)collectInfosCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS info_count FROM t_collect_info;"];
    [set next];
    return [set intForColumn:@"info_count"];
}


+ (void)addInfo:(RentInfoModel *)infoModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:infoModel];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_info(info, info_id) VALUES(%@, %@);", data, infoModel.id];
}


+ (void)removeCollect:(RentInfoModel *)infoModel
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_info WHERE info_id = %@;", infoModel.id];
}

+ (BOOL)isCollect:(RentInfoModel *)infoModel
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS info_count FROM t_collect_info WHERE info_id = %@;", infoModel.id];
    [set next];
    
    //#warning 索引从1开始
    return [set intForColumn:@"info_count"] == 1;
    
}


@end
