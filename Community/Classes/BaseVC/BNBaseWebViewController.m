//
//  BNBaseWebViewController.m
//  Community
//
//  Created by mac1 on 16/7/25.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "BNBaseWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "cc_macro.h"
@interface BNBaseWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>



@property (nonatomic, weak) UIWebView *webView;

@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@end

@implementation BNBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    self.navigationTitle = self.navTitle;
    //WebView清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight)];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    _webView = webView;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, NaviHeight - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;

    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *js = @"var title = document.getElementsByTagName('title')[0];";
//    [js stringByAppendingString:@"title.innerHTML;"];
//    NSLog(@"%@",[webView stringByEvaluatingJavaScriptFromString:js]);
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (!self.navTitle) {
//        NSString *js = @"var title = document.getElementsByTagName('title')[0];";
//        [js stringByAppendingString:@"title.innerHTML;"];
//        NSLog(@"%@",[_webView stringByEvaluatingJavaScriptFromString:js]);
        self.navigationTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
