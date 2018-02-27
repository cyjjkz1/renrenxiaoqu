//
//  LCPickerView.h
//  Community
//
//  Created by mac1 on 16/8/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseTypeModel.h"

@class LCPickerView;

@protocol LCPickerViewDataSouce <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(LCPickerView *)pickerView;

- (NSInteger)pickerView:(LCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@optional
- (HouseTypeModel *)myPickerView:(LCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (NSString *)lc_pickerView:(LCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end


@protocol LCPickerViewDelegate <NSObject>

@optional

- (void)pickerView:(LCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewDidCancel:(LCPickerView *)pickerView;

@end


@interface LCPickerView : UIView

@property (nonatomic, weak) id<LCPickerViewDataSouce> dataSouce;
@property (nonatomic, weak) id<LCPickerViewDelegate> delegate;

//让picker选中某一行
- (void)setSelectedRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)showInView:(UIView *)view;
- (void)dismissPickerView;

@end
