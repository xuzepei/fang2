//
//  RCShuiFeiViewController.h
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCShuiFeiViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIButton* calculateButton;
@property(nonatomic,retain)UITextField* danjiaTF;
@property(nonatomic,retain)UITextField* mianjiTF;

- (void)initTableView;


@end
