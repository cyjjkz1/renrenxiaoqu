//
//  UIView+LCFrame.m
//  WuXianXian
//
//  Created by mac1 on 16/2/23.
//  Copyright © 2016年 xujiayong. All rights reserved.
//

#import "UIView+LCFrame.h"

@implementation UIView (LCFrame)

-(void)setH:(float)h{
    CGRect frm = self.frame;
    frm.size.height = h;
    self.frame = frm;
}

-(float)h{
    return self.frame.size.height;
}

-(void)setW:(float)w{
    CGRect frm = self.frame;
    frm.size.width = w;
    self.frame = frm;
}

-(float)w{
    return self.frame.size.width;
}



- (void)setX:(float)x
{
    CGRect frm = self.frame;
    frm.origin.x = x;
    self.frame = frm;
}
- (float)x{
    return self.frame.origin.x;
}





-(void)setY:(float)y{
    CGRect frm = self.frame;
    frm.origin.y = y;
    self.frame = frm;
    
}

-(float)y{
    return self.frame.origin.y;
}

- (void)setCenterX:(float)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}

- (float)centerX
{
    return self.center.x;
}

- (void)setCenterY:(float)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
    
}

- (float)centerY
{
    return self.center.y;
}

- (void)setMaxY:(float)maxY
{
    CGRect rect = self.frame;
    rect.origin.y = maxY - rect.size.height;
    self.frame = rect;
}
- (float)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxX:(float)maxX
{
    CGRect rect = self.frame;
    rect.origin.x = maxX - rect.size.width;
    self.frame = rect;
}

- (float)maxX
{
    return CGRectGetMaxX(self.frame);
}


@end
