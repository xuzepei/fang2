//
//  RCMapViewController.h
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RCMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
}

@property(nonatomic,retain)MKMapView* mapView;
@property(nonatomic,retain)CLLocationManager* locationManager;
@property(nonatomic,retain)CLLocation* location;
@property(nonatomic,retain)NSString* coordinate;
@property(nonatomic,retain)NSString* latlng;
@property(assign)BOOL isValidCoordinate;


- (void)initMapView;
- (void)updateContent:(NSString*)latlng;
- (void)getGPS:(id)token;

@end
