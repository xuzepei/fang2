//
//  RCThisMonthViewController.h
//  RCFang
//
//  Created by xuzepei on 5/7/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCButtonView.h"
#import "RCPickerView.h"
#import "RCAdScrollView.h"

@interface RCThisMonthViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,RCButtonViewDelegate,RCPickerViewDelegate,RCAdScrollViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIView* headerView;
@property(nonatomic,retain)RCButtonView* headerButton0;
@property(nonatomic,retain)RCButtonView* headerButton1;
@property(nonatomic,retain)RCButtonView* headerButton2;
@property(nonatomic,retain)RCButtonView* headerButton3;
@property(assign)NSUInteger quyuIndex;
@property(assign)NSUInteger leixingIndex;
@property(assign)NSUInteger jiageIndex;
@property(assign)NSUInteger paixuIndex;
@property(nonatomic,retain)RCPickerView* pickerView;
@property(nonatomic,retain)NSDictionary* quyuSelection;
@property(nonatomic,retain)NSDictionary* leixingSelection;
@property(nonatomic,retain)NSDictionary* jiageSelection;
@property(nonatomic,retain)NSDictionary* paixuSelection;
@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(assign)int page;
@property(nonatomic,retain)NSString* count;
@property(assign)CGFloat adHeight;
@property(assign)NSUInteger quyuSearchId;
@property(assign)NSUInteger leixingSearchId;

- (void)initTableView;
- (void)updateContent;
- (void)initAdScrollView;

@end
