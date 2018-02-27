//
//  macro.h
//  test-iPhone-X
//
//  Created by mac on 2017/10/20.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#ifndef macro_h
#define macro_h

#define kCCScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kCCScreenHeight [[UIScreen mainScreen] bounds].size.height
//iPhone X
#define Is_Iphone       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X     (Is_Iphone && kCCScreenHeight == 812.0)
#define NaviHeight      (Is_Iphone_X ? 88 : 64)
#define StatusBarHeight (Is_Iphone_X ? 44 : 20)
#define TabbarHeight    (Is_Iphone_X ? 83 : 49)
#define BottomHeight    (Is_Iphone_X ? 34 : 0)

//kit width 以5s为基准
#define AdaptWidth(__width) (__width/320.f)*kCCScreenWidth
#define AdaptHeight(__height) (__height/568.f)*kCCScreenHeight

//kit width 以6为基准
#define AdaptWidth6Standard(__width) (__width/375.f)*kCCScreenWidth
#define AdaptHeight6Standard(__height) (__height/667.f)*kCCScreenHeight//iphone4的文字等可以按比例来
#define AdaptHeight6StandardNot4(__height) (__height/667.f)*(kCCScreenHeight<568 ? 568 : kScreenHeight)//iphone4的cell高度等以5为标准

#define kScreenWidth_scale  (kCCScreenWidth/320)

#define kScreenHeight_scale (kCCScreenHeight>568 ? kCCScreenHeight/568 : 1)

#endif /* macro_h */
