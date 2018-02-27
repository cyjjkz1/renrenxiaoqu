//
//  LCUploadProgress.m
//  Community
//
//  Created by mac1 on 2016/10/19.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "LCUploadProgress.h"

@interface LCUploadProgress ()


@property (nonatomic, assign) CGFloat theRadius;

@property (nonatomic, assign) CGFloat centerPointX;
@property (nonatomic, assign) CGFloat centerPointY;
@property (nonatomic, assign) CGFloat lineWidth; //线宽

@property (nonatomic, assign) double drawProgress;

@end

@implementation LCUploadProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat theMin = frame.size.width >= frame.size.height ? frame.size.height : frame.size.width;
        
        self.theRadius = theMin * 0.5 - 20;
        self.centerPointX = frame.size.width/2.0;
        self.centerPointY = frame.size.height/2.0;
        self.lineWidth = 10;
    }
    return self;
}


- (void)setProgress:(NSProgress *)progress
{
    _progress = progress;
    _drawProgress = progress.fractionCompleted;
    NSLog(@"draw 进度--->>>> %f",_drawProgress);
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self setNeedsDisplay];
    });
   
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    NSLog(@"%f",2 * M_PI * _drawProgress);
    CGContextAddArc(context, _centerPointX, _centerPointY, _theRadius, 0, 2 * M_PI * _drawProgress, NO);
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xff9700).CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGFloat progress100 = _drawProgress * 100;
    NSString *progressStr = [NSString stringWithFormat:@"上传进度：%.2f%%",progress100];
    NSAttributedString *atts = [[NSAttributedString alloc] initWithString:progressStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    [progressStr drawInRect:CGRectMake(_centerPointX - atts.size.width * 0.5, _centerPointY - atts.size.height * 0.5, atts.size.width, atts.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName : UIColorFromRGB(0xff9700)}];
    CGContextRestoreGState(context);
    
    
}


@end
