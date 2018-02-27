//
//  RentHouseTopItem.h
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentHouseTopItem : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (copy, nonatomic) void(^clickedBlock)(NSInteger clickIndex);


@end
