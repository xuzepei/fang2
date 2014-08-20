//
//  RCFJViewController.h
//  RCFang
//
//  Created by xuzepei on 6/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"
#import "RCButtonView.h"
#import "RCBaiDuMapViewController.h"
#import "RCAppDelegate.h"

@interface RCFJViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>


@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* condition0Selection;
@property(nonatomic,strong)NSDictionary* condition1Selection;
@property(nonatomic,strong)NSString* condition0;
@property(nonatomic,strong)NSString* condition1;
@property(nonatomic,strong)RCButtonView* headerButton0;
@property(nonatomic,strong)RCButtonView* headerButton1;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,assign)int pageno;
@property(nonatomic,strong)UIButton* refreshButton;
@property(nonatomic,strong)UILabel* locationLabel;
@property(nonatomic,assign)int page;

- (void)updateContent:(NSDictionary*)item;

@end
