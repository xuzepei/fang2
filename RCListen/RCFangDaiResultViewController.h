//
//  RCFangDaiResultViewController.h
//  RCFang
//
//  Created by xuzepei on 3/15/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFangDaiResultViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(assign)int daikuanType;
@property(nonatomic,retain)UILabel* headerLabel;
@property(nonatomic,retain)UILabel* footerLabel;


- (void)initTableView;

- (void)updateContent:(NSDictionary*)item daikuanType:(int)daikuanType;

@end
