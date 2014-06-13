//
//  RCRateTypeViewController.h
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFangDaiViewController.h"

@interface RCRateTypeViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)RCFangDaiViewController* delegate;
@property(assign)int selectedIndex;

- (void)initTableView;
- (void)updateContent:(NSArray*)itemArray selectedIndex:(int)selectedIndex;

@end
