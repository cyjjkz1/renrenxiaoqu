//
//  ShareSubmitView.m
//  ios
//
//  Created by xu jiayong on 15-4-5.
//  Copyright (c) 2015年 Boen. All rights reserved.
//

#import "ShareSubmitView.h"

@interface ShareSubmitView ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) UIView *whiteView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UITextView *textView;
@property (nonatomic) UILabel *placeholderLbl;
@property (nonatomic) UIButton *defaultBtn;

@end

@implementation ShareSubmitView
static CGFloat whiteViewHeight;
static NSInteger maxLength_TextView = 200;
#define kButtonHeight 44

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation)];
        [self addGestureRecognizer:tap];
        
        whiteViewHeight = 438*BILI_WIDTH;
        
        CGFloat originY = 0;
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(8*BILI_WIDTH, SCREEN_HEIGHT-whiteViewHeight-8*BILI_WIDTH, SCREEN_WIDTH-2*8*BILI_WIDTH, whiteViewHeight)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 3;
        _whiteView.layer.masksToBounds = YES;
        [self addSubview:_whiteView];
        _whiteView.center = self.center;
        //        _whiteView.transform = CGAffineTransformMakeTranslation(0, 0);
        _whiteView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
        [self addGestureRecognizer:tap1];
        
//        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation2)];
//        [_whiteView addGestureRecognizer:tap2];


        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 10*BILI_WIDTH, _whiteView.frame.size.width-2*10*BILI_WIDTH, _whiteView.frame.size.width-2*10*BILI_WIDTH)];
        _imageView.backgroundColor = UIColor_DarkGray_Text;
        [_whiteView addSubview:_imageView];
        
        originY += _imageView.frame.size.height +15*BILI_WIDTH;
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY, _whiteView.frame.size.width-2*15*BILI_WIDTH+10, whiteViewHeight-originY-(44+10)*BILI_WIDTH)];
        _textView.contentInset = UIEdgeInsetsMake(-5.0f, -5.0f, -5.0f, -5.0f);
        _textView.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        [_whiteView addSubview:_textView];
        _textView.text = @"";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
//        self.placeholderLbl = [[UILabel alloc]initWithFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y+5*BILI_WIDTH, _textView.frame.size.width, 14*BILI_WIDTH)];
//        _placeholderLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
//        _placeholderLbl.textColor = TextColorLightGray;
//        _placeholderLbl.backgroundColor = [UIColor clearColor];
//        [_whiteView addSubview:_placeholderLbl];
//        _placeholderLbl.text = @"何不来段个性短评呢";

        for (int i = 0; i < 2; i++) {
            
            NSString *btnTitle = (i == 0 ? @"取消" : @"分享");
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.frame = CGRectMake(i*_whiteView.frame.size.width/2, _whiteView.frame.size.height-kButtonHeight, _whiteView.frame.size.width/2, kButtonHeight);
            //seperator
            button.backgroundColor = [UIColor whiteColor];
            button.layer.shadowColor = [[UIColor grayColor] CGColor];
            button.layer.shadowRadius = 0.5;
            button.layer.shadowOpacity = 1;
            button.layer.shadowOffset = CGSizeZero;
            button.layer.masksToBounds = NO;
            button.tag = 100+ i;
            // title
            [button setTitle:btnTitle forState:UIControlStateNormal];
            [button setTitle:btnTitle forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            if (btnTitle && ([btnTitle isEqualToString:@"放弃"] || [btnTitle isEqualToString:@"取消"])) {
                [button setTitleColor:UIColor_DarkGray_Text forState:UIControlStateNormal];
            } else {
                [button setTitleColor:UIColor_DarkGray_Text forState:UIControlStateNormal];
            }
            // action
            [button addTarget:self
                       action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [_whiteView addSubview:button];
        }
    }
    return self;
}

- (void)appearAnimation
{
    self.hidden = NO;
    if ([_imageUrl isEqualToString:@"UseLocalImageToShare"]) {
        _imageView.image = [UIImage imageNamed:@"share.jpg"];
        _textView.text = [NSString stringWithFormat:@"%@",_goodsTitle];
    } else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
        _textView.text = [NSString stringWithFormat:@"《%@》@品客云集－#汇集一线设计师私藏品#",_goodsTitle];
    }

    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];
        
        _whiteView.transform = CGAffineTransformMakeTranslation(0, 0);

    } completion:^(BOOL finished) {
//        [_textView becomeFirstResponder];
    }];
}
- (void)disAppearAnimation
{
    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.0];
        _whiteView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)disAppearAnimation2
{
}
- (void)hideKeyboard
{
    [_textView resignFirstResponder];
}
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 100:{
            //cancelBtn
            [self disAppearAnimation];
            break;
        }
        case 101:{
            //分享按钮
            if (_textView.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"内容不能为空！"];
                return;
            }
            if ([self.delegate respondsToSelector:@selector(ShareSubmitViewDelegateSelectBtn:image:text:goodsUrl:imgUrl:)]) {
                UIImage *image ;
                if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_imageUrl]] || [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:_imageUrl]]) {
                    UIImageView *imgview = [[UIImageView alloc]init];
                    [imgview sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
                    
                    image = imgview.image;
                } else {
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
                    image = [UIImage imageWithData:imgData];
                }

                [_delegate ShareSubmitViewDelegateSelectBtn:self image:image text:_textView.text goodsUrl:_goodsUrl imgUrl:_imageUrl];
            }
            break;
        }
    }
}
#pragma mark -NSNotification事件
//当键盘高度改变时调用
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //
    CGAffineTransform transform = self.whiteView.transform;
    
    if (endFrame.origin.y == SCREEN_HEIGHT && transform.ty < 0) {
        //键盘隐藏时
        self.whiteView.transform = CGAffineTransformMakeTranslation(0, 0);
    }else  {
        //键盘出现或切换键盘类型时
        [UIView animateWithDuration:duration animations:^{
            self.whiteView.transform = CGAffineTransformMakeTranslation(0, -(SCREEN_HEIGHT-endFrame.origin.y)+(SCREEN_HEIGHT-whiteViewHeight)/2-8*BILI_WIDTH);
        }];
    }
}

#pragma mark - UITextFieldDelegate, UITextViewDelegate

-(void)refreshTextViewText
{
//    NSInteger count = maxLength_TextView-_textView.text.length;
//    _textCountLbl.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (_textView.text.length > 0) {
        _defaultBtn.enabled = YES;
    } else{
        _defaultBtn.enabled = NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *allStr = [textView.text stringByAppendingString:text];
    if (allStr.length > maxLength_TextView) {
        return NO;
    }
    return YES;

//    if (text.length <= 0 && allStr.length > 0) {
//        textView.text = [allStr substringToIndex:allStr.length-1];
//    } else if (allStr.length > maxLength_TextView) {
//        textView.text = [allStr substringToIndex:maxLength_TextView];
//    } else {
//        textView.text = allStr;
//    }
//    [self refreshTextViewText];
//    
//    return YES;
}
@end
