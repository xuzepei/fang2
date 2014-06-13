//
//  RCZiXunViewController.h
//  RCFang
//
//  Created by xuzepei on 4/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCZiXunTabBar.h"
#import "RCAdScrollView.h"

@interface RCZiXunViewController : UIViewController<
UITableViewDataSource,UITableViewDelegate,RCZiXunTabBarDelegate,RCAdScrollViewDelegate,RCAdScrollViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)RCZiXunTabBar* tabBar;
@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSMutableArray* itemArray0;
@property(nonatomic,retain)NSMutableArray* itemArray1;
@property(nonatomic,retain)NSMutableArray* itemArray2;
@property(nonatomic,retain)NSMutableArray* itemArray3;
@property(assign)int page0;
@property(assign)int page1;
@property(assign)int page2;
@property(assign)int page3;
@property(assign)CGFloat adHeight;
@property(assign)int selectedIndex;
@property(assign)int type;

- (void)initTabBar;
- (void)initTableView;
- (void)updateContent:(int)type;

@end
