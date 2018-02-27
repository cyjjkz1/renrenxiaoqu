//
//  RentInfoModel.h
//  Community
//
//  Created by mac1 on 16/7/22.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentInfoModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *imageUrl; //imageUrl
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *theDescription; //描述
@property (nonatomic, copy) NSString *distance; //距离
@property (nonatomic, copy) NSString *date; //时间
@property (nonatomic, copy) NSString *type;  //articleType
@property (nonatomic, copy) NSString *authorName; //发布者姓名
@property (nonatomic, copy) NSString *authorMobile; //发布者电话
@property (nonatomic, copy) NSString *price; //价格
@property (nonatomic, copy) NSString *status; //状态

@property (nonatomic, copy) NSString *h5_url;

@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *houseType;  //厅室
@property (nonatomic, copy) NSString *decorationType;  //装修
@property (nonatomic, copy) NSString *direction; //朝向
@property (nonatomic, copy) NSString *payType;   //支付方式

+ (RentInfoModel *)modelWithDictionary:(NSDictionary *)dic;

@end
