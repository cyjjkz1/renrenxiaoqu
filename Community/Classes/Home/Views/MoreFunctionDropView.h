//
//  MoreFunctionDropView.h
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFunctionDropView : UIView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)titles;
@property (nonatomic, copy) void(^clickedBlock)(NSInteger clickIndex);

@end
