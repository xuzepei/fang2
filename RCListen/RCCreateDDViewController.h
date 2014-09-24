//
//  RCCreateDDViewController.h
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKPoiSearch.h"
#import "RCCreateDDSetp0View.h"
#import "BMapKit.h"

@interface RCCreateDDViewController : UIViewController

@property(nonatomic,strong)IBOutlet RCCreateDDSetp0View* setp0View;
@property(nonatomic,strong)BMKPoiInfo* qdInfo;
@property(nonatomic,strong)BMKPoiInfo* zdInfo;
@property(nonatomic,strong)BMKDrivingRouteLine* routePlan;

- (IBAction)clickedNextButton:(id)sender;

@end
