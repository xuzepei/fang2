//
//  RCYHJViewController.h
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface RCYHJViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)NSMutableArray* itemArray0;
@property(nonatomic,strong)NSMutableArray* itemArray1;
@property(nonatomic,assign)int page0;
@property(nonatomic,assign)int page1;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UISegmentedControl* segmentedControl;

- (void)updateContent;

@end
