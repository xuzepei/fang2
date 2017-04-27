//
//  RCSearchAddressTableViewController.h
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKPoiSearch.h"

@interface RCSearchAddressTableViewController : UITableViewController<UISearchBarDelegate,BMKPoiSearchDelegate>

@property(nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)BMKPoiSearch* search;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,weak)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
