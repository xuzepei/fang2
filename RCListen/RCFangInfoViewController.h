//
//  RCFangInfoViewController.h
//  RCFang
//
//  Created by xuzepei on 3/19/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"
#import "RCContactToolbar.h"
#import <MessageUI/MessageUI.h>

@interface RCFangInfoViewController : UIViewController
<RCAdScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSDictionary* detailInfo;
@property(nonatomic,retain)RCContactToolbar* toolbar;
@property(nonatomic,retain)UIButton* callButton;
@property(nonatomic,retain)UIButton* sendMessageButton;
@property(nonatomic,retain)NSArray* units;
@property(nonatomic,retain)NSString* delid;

- (void)updateContent:(NSDictionary*)item;
- (void)initAdScrollView;
- (void)initTableView;


@end
