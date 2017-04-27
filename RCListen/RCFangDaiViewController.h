//
//  RCFangDaiViewController.h
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

static float g_rate_sangdai_5[32] = {0.0640*1.1,0.0640*0.85,0.0640*0.7,0.0640,/*12.7.6*/
    0.0665*1.1,0.0665*0.85,0.0665*0.7,0.0665,/*12.6.8*/
    0.0690*1.1,0.0690*0.85,0.0690*0.7,0.0690,/*11.7.6*/
    0.0665*1.1,0.0665*0.85,0.0665*0.7,0.0665,/*11.4.6*/
    0.0645*1.1,0.0645*0.85,0.0645*0.7,0.0645,/*11.2.9*/
    0.0622*1.1,0.0622*0.85,0.0622*0.7,0.0622,/*10.12.26*/
    0.0596*1.1,0.0596*0.85,0.0596*0.7,0.0596,/*10.10.20*/
    0.0576*1.1,0.0576*0.85,0.0576*0.7,0.0576/*08.12.23*/};

static float g_rate_sangdai_30[32] = {0.0655*1.1,0.0655*0.85,0.0655*0.7,0.0655,/*12.7.6*/
    0.0680*1.1,0.0680*0.85,0.0680*0.7,0.0680,/*12.6.8*/
    0.0705*1.1,0.0705*0.85,0.0705*0.7,0.0705,/*11.7.6*/
    0.0680*1.1,0.0680*0.85,0.0680*0.7,0.0680,/*11.4.6*/
    0.0660*1.1,0.0660*0.85,0.0660*0.7,0.0660,/*11.2.9*/
    0.0640*1.1,0.0640*0.85,0.0640*0.7,0.0640,/*10.12.26*/
    0.0614*1.1,0.0614*0.85,0.0614*0.7,0.0614,/*10.10.20*/
    0.0594*1.1,0.0594*0.85,0.0594*0.7,0.0594/*08.12.23*/};

static float g_rate_gojijin_5[32] = {0.0400*1.1,0.0400*0.85,0.0400*0.7,0.0400,/*12.7.6*/
    0.0420*1.1,0.0420*0.85,0.0420*0.7,0.0420,/*12.6.8*/
    0.0445*1.1,0.0445*0.85,0.0445*0.7,0.0445,/*11.7.6*/
    0.0420*1.1,0.0420*0.85,0.0420*0.7,0.0420,/*11.4.6*/
    0.0400*1.1,0.0400*0.85,0.0400*0.7,0.0400,/*11.2.9*/
    0.0375*1.1,0.0375*0.85,0.0375*0.7,0.0375,/*10.12.26*/
    0.0350*1.1,0.0350*0.85,0.0350*0.7,0.0350,/*10.10.20*/
    0.0333*1.1,0.0333*0.85,0.0333*0.7,0.0333/*08.12.23*/};

static float g_rate_gojijin_30[32] = {0.0450*1.1,0.0450*0.85,0.0450*0.7,0.0450,/*12.7.6*/
    0.0470*1.1,0.0470*0.85,0.0470*0.7,0.0470,/*12.6.8*/
    0.0490*1.1,0.0490*0.85,0.0490*0.7,0.0490,/*11.7.6*/
    0.0470*1.1,0.0470*0.85,0.0470*0.7,0.0470,/*11.4.6*/
    0.0450*1.1,0.0450*0.85,0.0450*0.7,0.0450,/*11.2.9*/
    0.0430*1.1,0.0430*0.85,0.0430*0.7,0.0430,/*10.12.26*/
    0.0405*1.1,0.0405*0.85,0.0405*0.7,0.0405,/*10.10.20*/
    0.0387*1.1,0.0387*0.85,0.0387*0.7,0.0387/*08.12.23*/};


@interface RCFangDaiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIButton* calculateButton;
@property(nonatomic,retain)UISegmentedControl* segmentedControl;

@property(assign)NSUInteger huankuanType;
@property(assign)NSUInteger daikuanType;
@property(assign)NSUInteger anjieYear;
@property(assign)NSUInteger rateType;
@property(assign)CGFloat rate;
@property(nonatomic,retain)UITextField* sangdaiSum;
@property(nonatomic,retain)UITextField* gongjijinSum;

@property(nonatomic,retain)NSArray* daikuanTypeArray;
@property(nonatomic,retain)NSArray* anjieYearArray;
@property(nonatomic,retain)NSArray* rateTypeArray;



- (void)initTableView;


@end
