//
//  RCShuiFeiResultViewController.h
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCShuiFeiResultViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UILabel* headerLabel;
@property(nonatomic,retain)UILabel* footerLabel;


- (void)initTableView;

- (void)updateContent:(NSDictionary*)item;

@end
