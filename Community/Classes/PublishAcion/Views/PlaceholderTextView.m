//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()<UITextViewDelegate>
{
    UILabel *PlaceholderLabel;
}

@end
@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews {
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];

    self.placeholderColor = [UIColor lightGrayColor];
    PlaceholderLabel=[[UILabel alloc] init];
    PlaceholderLabel.font=[UIFont systemFontOfSize:12 * BILI_WIDTH];
    PlaceholderLabel.textColor = self.placeholderColor;
    PlaceholderLabel.numberOfLines = 0;
    PlaceholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setPlaceholder:(NSString *)placeholder{
    CGFloat height  = [Tools caleHeightWithTitle:placeholder font:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - 40];
    float left=2, top = 7;
    PlaceholderLabel.frame = CGRectMake(left, top, SCREEN_WIDTH - 50 * BILI_WIDTH, height);
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    else
        PlaceholderLabel.text=placeholder;
    _placeholder=placeholder;

    
}

//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-60, bounds.size.height);
    return rect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-60, bounds.size.height);
    return rect;
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
    
    
}



@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
