//
//  RCYueJunHuanKuanViewController.h
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCYueJunHuanKuanViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;

- (void)initTableView;
- (void)updateContent:(NSArray*)itemArray;

@end
