//
//  ShareSheetView.h
//  ios
//
//  Created by xu jiayong on 15-4-5.
//  Copyright (c) 2015年 Boen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShareButton.h"

@protocol ShareSheetViewDelegate <NSObject>

- (void)ShareSheetViewDelegateBtn:(CustomShareButton *)button;

@end
@interface ShareSheetView : UIView
@property (weak, nonatomic) id <ShareSheetViewDelegate> delegate;

- (void)appearAnimation;
- (void)disAppearAnimation;

@end
