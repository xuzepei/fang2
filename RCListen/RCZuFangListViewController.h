//
//  RCZuFangListViewController.h
//  RCFang
//
//  Created by xuzepei on 5/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCButtonView.h"
#import "RCPickerView.h"
#import "RCSecondHandHouseCell.h"
#import "RCAdScrollView.h"

@interface RCZuFangListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,RCButtonViewDelegate,RCPickerViewDelegate,RCAdScrollViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIView* headerView;
@property(nonatomic,retain)RCButtonView* headerButton0;
@property(nonatomic,retain)RCButtonView* headerButton1;
@property(nonatomic,retain)RCButtonView* headerButton2;
@property(nonatomic,retain)RCButtonView* headerButton3;
@property(assign)NSUInteger selectionIndex0;
@property(assign)NSUInteger selectionIndex1;
@property(assign)NSUInteger selectionIndex2;
@property(assign)NSUInteger selectionIndex3;
@property(nonatomic,retain)RCPickerView* pickerView;
@property(nonatomic,retain)NSDictionary* selection0;
@property(nonatomic,retain)NSDictionary* selection1;
@property(nonatomic,retain)NSDictionary* selection2;
@property(nonatomic,retain)NSDictionary* selection3;

@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(assign)CGFloat adHeight;

@property(assign)int page;
@property(nonatomic,retain)NSString* count;
@property(assign)NSUInteger quyuSearchId;

@property(nonatomic,retain)NSString* type;
@property(nonatomic,retain)NSDictionary* detailInfo;

@property(assign)int area;
@property(assign)int typeIndex;
@property(assign)int price;
@property(nonatomic,retain)NSString* keyword;

- (void)initTableView;
- (void)updateContent;
- (void)updateContent:(NSString*)type info:(NSDictionary*)info;
- (void)updateContent:(NSArray*)array count:(NSString*)count area:(int)area type:(int)type price:(int)price keyword:(NSString*)keyword;

@end
