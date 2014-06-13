//
//  RCFavoriteViewController.h
//  RCFang
//
//  Created by xuzepei on 5/3/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTabBar.h"
#import "RCAdScrollView.h"

@interface RCFavoriteViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,RCTabBarDelegate,RCAdScrollViewDelegate,RCAdScrollViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)RCTabBar* tabBar;
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

- (void)initTabBar;
- (void)initTableView;
- (void)updateContent:(HOUSE_TYPE)type page:(int)page index:(int)index;

@end
