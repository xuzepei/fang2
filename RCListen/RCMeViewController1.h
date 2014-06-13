//
//  RCMeViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <MessageUI/MessageUI.h>

@interface RCMeViewController1 : UIViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIButton* loginButton;


- (void)initTableView;

@end
