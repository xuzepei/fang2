//
//  RCHomeViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"
#import "ZBarSDK.h"
#import "RCSelectAreaButton.h"
#import "RCScrollLabel.h"

@interface RCHomeViewController : UIViewController<RCAdScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate>

@property(nonatomic,retain)NSMutableArray* adItems;
@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)CGFloat adScrollViewHeight;

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

@property(nonatomic,retain)RCSelectAreaButton* selectAreaButton;

- (void)initAdScrollView;
- (void)initTableView;
- (void)initButtons;
- (void)clickedLocationButton:(id)sender;

- (IBAction)clickedBJButton:(id)sender;
- (IBAction)clickedJZButton:(id)sender;
- (IBAction)clickedKDButton:(id)sender;

@end
