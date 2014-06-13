//
//  RCLocationController.h
//  RCFang
//
//  Created by xuzepei on 4/3/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RCLocationController : NSObject<CLLocationManagerDelegate>

@property(nonatomic,retain)CLLocationManager* locationManager;
@property(nonatomic,retain)CLLocation* location;
@property(nonatomic,retain)NSString* coordinate;

+ (RCLocationController*)sharedInstance;
- (void)startLocationService;
- (void)stopLocationService;

@end
