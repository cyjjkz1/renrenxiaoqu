//
//  RSMainVC.m
//  Community
//
//  Created by mac1 on 16/9/8.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "RSMainVC.h"
#import "RSViewController.h"
#import "RentingHouseViewController.h"
#import "AskRentSaleVC.h"
#import "cc_macro.h"
#import "PublishViewController.h"
@interface RSMainVC ()

@property (nonatomic, weak) UIButton *publishNewBtn;
@end

@implementation RSMainVC


- (instancetype)init
{
    if (self = [super init]) {
        self.segmentTextArray = @[@"住房租售", @"车位租售", @"求租求购"];
        
        RSViewController *vc2 = [[RSViewController alloc] init];
        RentingHouseViewController *vc3 = [[RentingHouseViewController alloc] init];
        AskRentSaleVC *vc4 = [[AskRentSaleVC alloc] init];
        self.pages = @[vc3, vc2, vc4].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"租售信息";
    self.backButton.hidden = YES;
    self.publishBtn.hidden = YES;
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(self.view.maxX - 74* BILI_WIDTH, self.contentContainer.h - TabbarHeight - 56 * BILI_WIDTH - 10 * BILI_WIDTH, 56* BILI_WIDTH, 56 * BILI_WIDTH);
    pButton.backgroundColor = UIColorFromRGB(0x0080ff);
    [pButton setImage:[UIImage imageNamed:@"icon_wraite"] forState:UIControlStateNormal];
    pButton.layer.cornerRadius = 28 * BILI_WIDTH;
    pButton.layer.masksToBounds = YES;
    [pButton addTarget:self action:@selector(publishActionKKK) forControlEvents:UIControlEventTouchUpInside];
    self.publishNewBtn = pButton;
    [self.contentContainer addSubview:pButton];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationWithPublicButton) name:kNotification_TableViewScroll object:nil];
}

- (void)animationWithPublicButton{
    
    CGFloat kAnimationDuration = 0.8f;
    
    CAGradientLayer *contentLayer = (CAGradientLayer *)self.publishNewBtn.layer;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)publishActionKKK
{
    PublishViewController *pubVC = [[PublishViewController alloc] init];
    [self pushViewController:pubVC animated:YES];
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
