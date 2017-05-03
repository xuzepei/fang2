//
//  RCNewsViewController.h
//  RCFang
//
//  Created by xuzepei on 4/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface RCNewsViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)int page0;

- (void)initTableView;
- (void)updateContent;
@end
