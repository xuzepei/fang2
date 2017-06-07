//
//  RCHomeViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"
#import "RCScrollLabel.h"
#import "Reachability.h"
#import "RCFuctionButton.h"

@interface RCHomeViewController : UIViewController<RCAdScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSMutableArray* adItems;
@property(nonatomic,retain)NSArray* hotNews;
@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)CGFloat adScrollViewHeight;
@property(nonatomic, strong)Reachability* internetReachable;
@property(nonatomic, strong)RCFuctionButton* firstButton;
@property(nonatomic, assign)BOOL isWifiConnected;
@property(nonatomic, assign)int httpStatusCode;
@property(nonatomic, assign)BOOL isChecking;
@property(nonatomic, assign)BOOL isClickedWifiButton;
@property(nonatomic, strong)NSTimer* checkTimer;
@property(nonatomic, assign)BOOL isRedirected;

@property(nonatomic, strong)RCScrollLabel* scrollLabel;

@property(nonatomic,retain)IBOutlet UIButton* banjiaButton;
@property(nonatomic,retain)IBOutlet UIButton* jiazhengButton;
@property(nonatomic,retain)IBOutlet UIButton* kuaidiButton;
@property(nonatomic,retain)IBOutlet UILabel* bjTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel* jzTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel* kdTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel* bjLabel;
@property(nonatomic,retain)IBOutlet UILabel* jzLabel;
@property(nonatomic,retain)IBOutlet UILabel* kdLabel;

- (void)initAdScrollView;
- (void)initTableView;
- (void)initButtons;
- (void)clickedLocationButton:(id)sender;

- (IBAction)clickedBJButton:(id)sender;
- (IBAction)clickedJZButton:(id)sender;
- (IBAction)clickedKDButton:(id)sender;

@end
