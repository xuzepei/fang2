//
//  RCMoreViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "RCGongGaoViewController.h"

@interface RCMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZBarCaptureDelegate>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)UILabel* versionLabel;
@property(nonatomic,strong)NSString* updateUrlString;


- (void)initTableView;

@end
