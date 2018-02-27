//
//  RentInfoViewController.m
//  Community
//
//  Created by mac1 on 16/6/30.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RentInfoViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "LCDataTool.h"

@interface RentInfoViewController ()<NJKWebViewProgressDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (nonatomic, weak) UIWebView *webView;

@end

@implementation RentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"租售信息";
    
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = 23*BILI_WIDTH;
    collect.frame = CGRectMake(SCREEN_WIDTH - buttonWidth - 13, (44-buttonWidth) * 0.5, buttonWidth, buttonWidth);
    [collect setBackgroundImage:[UIImage imageNamed:@"collection_unselected"] forState:UIControlStateNormal];
    [collect setBackgroundImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
    [collect addTarget:self action:@selector(collectionAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:collect];
    collect.selected = [LCDataTool isCollect:self.rentInfo];
    
    CGFloat shareBtnWidth = 18*BILI_WIDTH;
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(collect.x - shareBtnWidth - 13, (44-shareBtnWidth) * 0.5, shareBtnWidth, shareBtnWidth);
    [share setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:share];
    
    
    //WebView清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rentInfo.h5_url]];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    _webView = webView;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

    [_progressView removeFromSuperview];
}


#pragma mark -UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (!self.navTitle) {
        self.navigationTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

//收藏一个信息
- (void)collectionAcion:(UIButton *)button
{
    if (button.isSelected) { // 取消收藏
        [LCDataTool removeCollect:self.rentInfo];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
        
    } else { // 收藏
        [LCDataTool addInfo:self.rentInfo];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }
    
    // 按钮的选中取反
    button.selected = !button.isSelected;
}

//分享
- (void)shareAcion
{
    NSString *goodsUrl = [NSString stringWithFormat:@"https://www.baidu.com"];
    [self showShareViewWithText:@"春哥为您服务" imgUrl:@"http://f.hiphotos.baidu.com/imgad/pic/item/b3fb43166d224f4a7d50937e0ef790529922d196.jpg" goodsUrl:goodsUrl];
}

@end
