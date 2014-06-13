//
//  RCMapAnnotation.h
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RCMapAnnotation : NSObject
<MKAnnotation>

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)myCoordinate;

@end
