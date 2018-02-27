//
//  THSegmentedPager.h
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "BNBaseViewController.h"
#import <HMSegmentedControl@hons82/HMSegmentedControl.h>


@interface THSegmentedPager : BNBaseViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) HMSegmentedControl *pageControl;
@property (strong, nonatomic) UIView *contentContainer;

@property (strong, nonatomic) NSMutableArray *pages;  //controllers
@property (strong, nonatomic) NSArray *segmentTextArray;

@property (nonatomic) BOOL haveSearchBtn;

//@property (copy, nonatomic) void(^selectedViewControllerBolck)(UIViewController *viewController);

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;



//- (void)updateTitleLabels;

@end
