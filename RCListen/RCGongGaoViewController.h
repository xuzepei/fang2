//
//  RCGongGaoViewController.h
//  RCFang
//
//  Created by xuzepei on 11/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface RCGongGaoViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,assign)int page;

@end
