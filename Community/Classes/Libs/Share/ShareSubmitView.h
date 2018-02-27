//
//  ShareSubmitView.h
//  ios
//
//  Created by xu jiayong on 15-4-5.
//  Copyright (c) 2015年 Boen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareSubmitView;

@protocol ShareSubmitViewDelegate <NSObject>

- (void)ShareSubmitViewDelegateSelectBtn:(ShareSubmitView *)selfView image:(id)image text:(NSString *)text goodsUrl:(NSString *)goodsUrl imgUrl:(NSString *)imgUrl;

@end
@interface ShareSubmitView : UIView

@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *goodsTitle;
@property (nonatomic) NSString *goodsUrl;

@property (weak, nonatomic) id <ShareSubmitViewDelegate> delegate;

- (void)appearAnimation;
- (void)disAppearAnimation;

@end
