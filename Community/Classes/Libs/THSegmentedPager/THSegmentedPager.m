//
//  THSegmentedPager.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "THSegmentedPager.h"
#import "cc_macro.h"
@interface THSegmentedPager ()
@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (weak, nonatomic) UIButton *rightButton;

@end

@implementation THSegmentedPager

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.backButton.hidden = YES;
    
    
    
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(SCREEN_WIDTH-44*BILI_WIDTH, 0, 44*BILI_WIDTH, 44);
    //    rightButton.tag = 101;
    //    [rightButton setImage:[UIImage imageNamed:@"OwnerCenter_Btn_Search"] forState:UIControlStateNormal];
    //    rightButton.imageEdgeInsets = UIEdgeInsetsMake(10*BILI_WIDTH, 10*BILI_WIDTH, 10*BILI_WIDTH, 10*BILI_WIDTH);
    //    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.customNavigationBar addSubview:rightButton];
    //    _rightButton = rightButton;
    //    _rightButton.hidden = !_haveSearchBtn;
    
    self.contentContainer = [[UIView alloc]initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight)];
    _contentContainer.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:_contentContainer];
    
    self.pageControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.textColor = UIColor_Gray_Text;
    self.pageControl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    self.pageControl.verticalDividerColor = [UIColor clearColor];
    self.pageControl.selectionIndicatorColor = UIColorFromRGB(0x2287f3);
    self.pageControl.selectionIndicatorHeight = 3;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectedTextColor = [UIColor blackColor];
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.pageControl.showVerticalDivider = YES;
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self.contentContainer addSubview:self.pageControl];
    
    CGRect segmentRect = [self setSegmentView:@[]];
    _pageControl.frame = segmentRect;
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, _pageControl.frame.size.height-1, SCREEN_WIDTH, 1)];
    line0.backgroundColor = UIColor_GrayLine;
    [self.pageControl insertSubview:line0 atIndex:1];
    
    // Init PageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, segmentRect.size.height, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height-segmentRect.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    
    [self.contentContainer addSubview:self.pageViewController.view];
    
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
//        _selectedViewControllerBolck(self.pages[0]);
    }
    
}
- (CGRect)setSegmentView:(NSArray *)segmentTextArray
{
    CGFloat segmentHeight = 35*BILI_WIDTH-2;
    
    
    if (segmentTextArray.count > 0) {
        [self.pageControl setSectionTitles:segmentTextArray];
    }
    return CGRectMake(0, 0, SCREEN_WIDTH, segmentHeight);
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    if ([self.pages count]>0) {
    //        [self.pageViewController setViewControllers:@[self.pages[0]]
    //                                          direction:UIPageViewControllerNavigationDirectionForward
    //                                           animated:NO
    //                                         completion:NULL];
    //    }
    [self updateTitleLabels];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - Setup

- (void)updateTitleLabels
{
    //    [self.pageControl setSectionTitles:[self titleLabels]];
    
    [self setSegmentView:_segmentTextArray];
    
}
//
//- (NSArray *)titleLabels
//{
//    NSArray *titles = @[@"已经使用", @"还未使用"];
////    for (UIViewController *vc in self.pages) {
////        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
////            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
////        } else {
////            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
////        }
////    }
//    return [titles copy];
//}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
//        _selectedViewControllerBolck(self.pages[index]);
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
//    _selectedViewControllerBolck([self selectedController]);

}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
//   _selectedViewControllerBolck([self selectedController]);
}

- (void)showSearchButton:(NSNotification *)notification
{
    NSString *hidden = notification.object;
    _rightButton.hidden = ![hidden isEqualToString:@"yes"];
    
}


@end
