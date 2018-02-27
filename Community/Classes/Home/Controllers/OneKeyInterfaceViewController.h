//
//  OneKeyInterfaceViewController.h
//  BLKApp
//
//  Created by roryyang on 16/8/13.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHBle.h"
@interface OneKeyInterfaceViewController : UIViewController<DHBleDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *myscrollview;
@property (strong, nonatomic) DHBle *sensor;
@property (strong, nonatomic) CBPeripheral *peripheral;

@end
