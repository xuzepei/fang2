//
//  RCSearchViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTabBar.h"
#import "RCPickerView.h"
#import "RCSearchCell.h"

@interface RCSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RCTabBarDelegate,RCPickerViewDelegate,UISearchBarDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)RCTabBar* tabBar;
@property(nonatomic,retain)UISearchBar* searchBar;
@property(nonatomic,retain)UIButton* searchButton;
@property(nonatomic,retain)RCPickerView* pickerView;
@property(assign)int selectedIndex;

- (void)initTabBar;
- (void)initSearchBar;
- (void)initTableView;
- (void)initButtons;
- (void)initPickerView;

@end
