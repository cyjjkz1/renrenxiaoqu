//
//  BNWelcomeVC.m
//  Community
//
//  Created by mac1 on 2016/10/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNWelcomeVC.h"
#import "LoginViewController.h"
#import "BNNavigationController.h"

@interface BNWelcomeVC ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation BNWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    self.customNavigationBar.hidden = YES;
    self.sixtyFourPixelsView.hidden = YES;
    
    NSArray *imageNames = @[@"intro_one", @"intro_two", @"intro_three"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imageNames.count, SCREEN_HEIGHT);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    for (int i = 0;  i < imageNames.count; i ++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:bgView];
        
        CGFloat imageW = 235, imageH = 249;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imageW) * 0.5, (SCREEN_HEIGHT - imageH) * 0.5 - 50*NEW_BILI, imageW, imageH)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [bgView addSubview:imageView];
        
        if (i == imageNames.count - 1) {
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat h = [BNTools sizeFitfour:20 five:40*NEW_BILI six:40*NEW_BILI sixPlus:40*NEW_BILI];
            goBtn.frame = CGRectMake(10, imageView.maxY + h, SCREEN_WIDTH - 20, 40);
            [goBtn setuporangeBtnTitle:@"立即体验" enable:YES];
            [goBtn addTarget:self action:@selector(goApp) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:goBtn];
        }
    }
    
    CGFloat pageWith = 80;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - pageWith) * 0.5, SCREEN_HEIGHT - 80, pageWith, 20)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = BNColorRGB(255, 151, 0);
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat page = contentOffsetX / SCREEN_WIDTH;
    
    NSLog(@"page --->>> %f",page);
    
    if (page >= 0 && page < 1) {
        _pageControl.currentPage = 0;
    }else if (page >= 1 && page < 2){
        _pageControl.currentPage = 1;
    }else if(page >= 2){
        _pageControl.currentPage = 2;
    }
    
    if (page > 2.1) {
        //进入App
        [self goApp];
    }
}


- (void)goApp
{
    NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [kUserDefaults setFloat:thisVersion.floatValue forKey:kVersionKey];
    [kUserDefaults synchronize];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    BNNavigationController *nav = [[BNNavigationController alloc] initWithRootViewController:loginVC];
    [self pushViewController:loginVC animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
