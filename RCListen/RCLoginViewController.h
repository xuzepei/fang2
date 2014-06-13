//
//  RCLoginViewController.h
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"

@interface RCLoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OHAttributedLabelDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIButton* loginButton;
@property(nonatomic,retain)UITextField* accountTF;
@property(nonatomic,retain)UITextField* passwordTF;
@property(nonatomic,retain)OHAttributedLabel* attributedLabel;

- (void)initTableView;

@end
