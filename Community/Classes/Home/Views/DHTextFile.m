//
//  DHTextFile.m
//  BLKApp
//
//  Created by roryyang on 16/8/15.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import "DHTextFile.h"

@implementation DHTextFile

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) initView{
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}
@end
