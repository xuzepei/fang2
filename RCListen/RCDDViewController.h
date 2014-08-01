//
//  RCDDViewController.h
//  RCFang
//
//  Created by xuzepei on 6/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDDViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)NSMutableArray* itemArray0;
@property(nonatomic,strong)NSMutableArray* itemArray1;
@property(nonatomic,strong)NSMutableArray* itemArray2;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UISegmentedControl* segmentedControl;

@end
