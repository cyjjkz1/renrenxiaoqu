//
//  RentInfoModel.m
//  Community
//
//  Created by mac1 on 16/7/22.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RentInfoModel.h"

@interface RentInfoModel ()

@property (nonatomic, strong) NSDictionary *tempDic;
@property (nonatomic, strong) NSDictionary *houseTypeDic;
@property (nonatomic, strong) NSDictionary *decorationTypeDic;
@property (nonatomic, strong) NSDictionary *directionDic;
@property (nonatomic, strong) NSDictionary *payTypeDic;

@end

@implementation RentInfoModel

- (NSDictionary *)tempDic
{
    if (!_tempDic) {
        _tempDic = @{@"1":@"房屋出租",
                     @"2":@"房屋出售",
                     @"5":@"房屋求租",
                     @"6":@"房屋求购",
                     @"3":@"车位出租",
                     @"4":@"车位出售",
                     @"7":@"车位求租",
                     @"8":@"车位求购"
                     };
    }
    return _tempDic;
}

- (NSDictionary *)houseTypeDic
{
    if (!_houseTypeDic) {
        _houseTypeDic = @{@"1":@"标间", @"2": @"套二" , @"3" : @"套三"};
    }
    return _houseTypeDic;
}

- (NSDictionary *)decorationTypeDic
{
    if (!_decorationTypeDic) {
        _decorationTypeDic = @{@"1":@"简装修", @"2":@"精装修", @"3":@"豪华装修"};
    }
    return _decorationTypeDic;
}

- (NSDictionary *)directionDic
{
    if (!_directionDic) {
        _directionDic = @{@"1":@"朝向东", @"2" : @"朝向西" , @"3": @"朝向南", @"4":@"朝向北"};
    }
    return _directionDic;
}

- (NSDictionary *)payTypeDic
{
    if (!_payTypeDic) {
        _payTypeDic = @{@"1":@"押一付一", @"2": @"押一付三", @"3": @"一年起租"};
    }
    return _payTypeDic;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_theDescription forKey:@"theDescription"];
    [aCoder encodeObject:_distance forKey:@"distance"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_h5_url forKey:@"h5_url"];
    
    [aCoder encodeObject:_houseType forKey:@"houseType"];
    [aCoder encodeObject:_decorationType forKey:@"decorationType"];
    [aCoder encodeObject:_direction forKey:@"direction"];
    [aCoder encodeObject:_payType forKey:@"payType"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_authorName forKey:@"authorName"];
    [aCoder encodeObject:_authorMobile forKey:@"authorMobile"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_status forKey:@"status"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {

        _id = [aDecoder decodeObjectForKey:@"id"];
        _imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _theDescription = [aDecoder decodeObjectForKey:@"theDescription"];
        _distance = [aDecoder decodeObjectForKey:@"distance"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _h5_url = [aDecoder decodeObjectForKey:@"h5_url"];
        
        _houseType = [aDecoder decodeObjectForKey:@"houseType"];
        _decorationType = [aDecoder decodeObjectForKey:@"decorationType"];
        _direction = [aDecoder decodeObjectForKey:@"direction"];
        _payType = [aDecoder decodeObjectForKey:@"payType"];
        _address = [aDecoder decodeObjectForKey:@"address"];
        _authorMobile = [aDecoder decodeObjectForKey:@"authorMobile"];
        _authorName = [aDecoder decodeObjectForKey:@"authorName"];
        _price = [aDecoder decodeObjectForKey:@"price"];
        _status = [aDecoder decodeObjectForKey:@"status"];
        
    }
    return self;
    
}
/*
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *theDescription;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *h5_url;
*/

+ (RentInfoModel *)modelWithDictionary:(NSDictionary *)dic
{
    RentInfoModel *model = [[RentInfoModel alloc] init];
    
    model.id = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"id"]];
    NSString *createTime = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"createtime"]];
    model.date = [self changeStempWithDateString:createTime];
    NSString *type = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"articleType"]];
    model.type = model.tempDic[type];
    model.title = [dic valueNotNullForKey:@"title"];
    model.theDescription = [dic valueNotNullForKey:@"desp"];
    model.address = [dic valueNotNullForKey:@"address"];
    model.authorName = [dic valueNotNullForKey:@"authorName"];
    model.authorMobile = [dic valueNotNullForKey:@"authorMobile"];
    model.price = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"price"]];
    model.status = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"status"]];
    
    //厅室
    NSString *houseType = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"houseType"]];
    model.houseType = [model.houseTypeDic valueNotNullForKey:houseType];
    
    //装修
    NSString *decorationType = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"decorationType"]];
    model.decorationType = [model.decorationTypeDic valueNotNullForKey:decorationType];
    
    //朝向
    NSString *direction = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"direction"]];
    model.direction = [model.directionDic valueNotNullForKey:direction];
    
    //支付
    NSString *payType = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"payType"]];
    model.payType = [model.payTypeDic valueNotNullForKey:payType];
    
    //照片
    id photo = [dic valueNotNullForKey:@"photos"];
    NSString *photoUrl = @"";
    if ([photo isKindOfClass:[NSArray class]]) {
        photo = (NSArray *)photo;
        if ([photo count] == 0) {
            NSLog(@"没有照片");
        }else{
            photoUrl = [[photo objectAtIndex:0] valueNotNullForKey:@"visitUrl"];
        }
    }else{
//        photoUrl = photo;
    }
    model.imageUrl = photoUrl;
    
    //数据暂无
    model.h5_url = @"http://www.baidu.com";
    return model;
}


+ (NSString *)changeStempWithDateString:(NSString *)stemp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stemp.longLongValue/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *str = [formatter stringFromDate:date];
    return str;
}


//MJCodingImplementation;

@end
