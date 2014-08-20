//
//  RCBaiDuMapViewController.h
//  RCFang
//
//  Created by xuzepei on 10/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RCAppDelegate.h"

@interface RCBaiDuMapViewController : UIViewController<BMKMapViewDelegate>


@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)NSString* address;
@property(nonatomic,strong)NSString* myTitle;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)UIStepper* stepper;
@property(nonatomic,strong)UIButton* locationButton;

- (void)updateContent:(NSDictionary*)item zoom:(int)zoom;
- (void)updateContent:(NSDictionary*)item;
- (void)addAnnotation:(NSString*)address title:(NSString*)title token:(id)token;

@end
