//
//  RCLocationController.m
//  RCFang
//
//  Created by xuzepei on 4/3/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCLocationController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "iToast.h"

@implementation RCLocationController

+ (RCLocationController*)sharedInstance
{
	static RCLocationController* sharedInstance = nil;
	if (nil == sharedInstance)
	{
		@synchronized([RCLocationController class])
		{
            if(nil == sharedInstance)
            {
                sharedInstance = [[RCLocationController alloc] init];
            }
		}
	}
    
	return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        if(NO == [CLLocationManager locationServicesEnabled])
        {
            [RCTool showAlert:@"提示" message:@"定位服务已关闭，请先在系统设置中打开定位服务。"];
        }
        else
        {
            if(nil == _locationManager)
            {
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
                _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    if(_locationManager)
        _locationManager.delegate = nil;
    self.locationManager = nil;
    self.location = nil;
    self.coordinate = nil;

}

- (void)startLocationService
{
    if(_locationManager)
        [_locationManager startUpdatingLocation];
}

- (void)stopLocationService
{
    if(_locationManager)
        [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
	NSLog(@"locationManager:didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
	NSLog(@"locationManager:didUpdateToLocation: %@ from %@", newLocation, oldLocation);
    
    self.location = newLocation;
    if(_location)
    {
        self.coordinate = [NSString stringWithFormat:@"%lf,%lf",_location.coordinate.latitude,_location.coordinate.longitude];
    }
    
    [self stopLocationService];
    
    if([self.coordinate length])
    {
        NSString* urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&language=zh-CN&sensor=true",_coordinate];
        
        RCHttpRequest* temp = [RCHttpRequest sharedInstance];
        BOOL b = [temp request:urlString delegate:self resultSelector:@selector(gotAddressName:) token:nil];
        if(b)
        {
            //[RCTool showIndicator:@"定位中,请稍候..."];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
	NSString *event = [NSString stringWithFormat:@"didEnterRegion %@ at %@", region.identifier, [NSDate date]];
    
    NSLog(@"didEnterRegion:%@",event);
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSString *event = [NSString stringWithFormat:@"didExitRegion %@ at %@", region.identifier, [NSDate date]];
    
    NSLog(@"didExitRegion:%@",event);
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
	
    NSLog(@"monitoringDidFailForRegion:%@",event);
}

- (void)gotAddressName:(NSString*)jsonString
{
    //[RCTool hideIndicator];
    
    NSDictionary* address = [RCTool parseAddress:jsonString];
    if(nil == address)
    {
        [RCTool showAlert:@"提示" message:@"获取定位信息失败，请检查网络稍后尝试！"];
    }
    else
    {
        //NSLog(@"address:%@",address);
        
        NSMutableString* temp = [[NSMutableString alloc] init];
        [temp appendString:@"当前位置:"];
        NSString* city = [address objectForKey:@"city"];
        if([city length])
        {
            [temp appendString:city];
            [temp appendString:@","];
        }
        
        NSString* area = [address objectForKey:@"area"];
        if([area length])
        {
            [temp appendString:area];
            [temp appendString:@","];
        }
        
        NSString* road = [address objectForKey:@"road"];
        if([road length])
            [temp appendString:road];

        [[iToast makeText:temp] show];
    }

}


@end
