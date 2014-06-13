//
//  RCMeViewController.h
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMeTopView.h"
#import "RCMeTabBar.h"

@interface RCMeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)RCMeTopView* topView;
@property(nonatomic,retain)RCMeTabBar* tabBar;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;

- (void)initTableView;

@end
