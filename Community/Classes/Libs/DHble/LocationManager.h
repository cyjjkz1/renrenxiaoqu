//
//  LocationManager.h
//  BLKApp
//
//  Created by ouge on 16/6/26.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kUUID @"68747470-3A77-7777-2E65-65756E2E636E"

@interface LocationManager : NSObject<CLLocationManagerDelegate>



+(LocationManager*) sharedManager;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion    *myBeacon;




-(void)startBeacon:(float)deviceVersion;

@end
