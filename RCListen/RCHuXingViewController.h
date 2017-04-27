//
//  RCHuXingViewController.h
//  RCFang
//
//  Created by xuzepei on 4/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"

@interface RCHuXingViewController : UIViewController
<RCAdScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSDictionary* detailInfo;
@property(assign)CGFloat adHeight;

- (void)updateContent:(NSDictionary*)item;


@end
