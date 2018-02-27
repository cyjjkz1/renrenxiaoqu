//
//  LCPickerView.m
//  Community
//
//  Created by mac1 on 16/8/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "LCPickerView.h"


@interface LCPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak)  UIPickerView *pickerView;

@end

@implementation LCPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 55, 36);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB(0x0080ff) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(frame.size.width - 55, 0, 55, 36);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:UIColorFromRGB(0x0080ff) forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  40, frame.size.width, frame.size.height - 40)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self  addSubview:pickerView];
        _pickerView = pickerView;
    }
    return self;
    
}


#pragma mark- UIPickerViewDelegate and DataSoruce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return [self.dataSouce numberOfComponentsInPickerView:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSouce pickerView:self numberOfRowsInComponent:component];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.dataSouce respondsToSelector:@selector(myPickerView:titleForRow:forComponent:)]) {
        HouseTypeModel *model = [self.dataSouce myPickerView:self titleForRow:row forComponent:component];
        return  model.text;
    }else if([self.dataSouce respondsToSelector:@selector(lc_pickerView:titleForRow:forComponent:)]) {
        return [self.dataSouce lc_pickerView:self titleForRow:row forComponent:component];
    }else{
        return @" ";
    }
   
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
}



- (void)cancel
{
    if ([self.delegate respondsToSelector:@selector(pickerViewDidCancel:)]) {
        [self.delegate pickerViewDidCancel:self];
    }
    [self dismissPickerView];
}

-(void)confirm
{
    [self dismissPickerView];
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, view.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

//让picker选中某一行，直接走代理
- (void)setSelectedRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    };
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
