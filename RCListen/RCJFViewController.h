//
//  RCJFViewController.h
//  RCFang
//
//  Created by xuzepei on 10/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMeTopView.h"
#import "RCMeTabBar.h"

@interface RCJFViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)RCMeTopView* topView;
@property(nonatomic,strong)RCMeTabBar* tabBar;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)NSDictionary* item;

- (void)initTableView;
- (void)updateContent;

@end
