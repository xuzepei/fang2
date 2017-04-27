//
//  RCCommentViewController.h
//  RCFang
//
//  Created by xuzepei on 4/7/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)int page;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UIView* inputBar;
@property(nonatomic,retain)UITextField* inputTF;
@property(nonatomic,retain)UIButton* sendButton;

- (void)updateContent:(NSDictionary*)item;

@end
