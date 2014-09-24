//
//  RCGuiHuaViewController.h
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RCGuiHuaViewController : UIViewController<UITextFieldDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>

@property(nonatomic,strong)IBOutlet UITextField* tf0;
@property(nonatomic,strong)IBOutlet UITextField* tf1;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)IBOutlet BMKMapView* mapView;
@property(nonatomic,strong)BMKRouteSearch* search;

@property(nonatomic,strong)BMKPoiInfo* qdInfo;
@property(nonatomic,strong)BMKPoiInfo* zdInfo;
@property(nonatomic,strong)BMKDrivingRouteLine* routePlan;

- (void)updateContent:(NSDictionary*)item;
- (void)addOverlay:(NSString*)address;

@end
