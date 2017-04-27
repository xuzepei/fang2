//
//  RCPasswordViewController.h
//  RCFang
//
//  Created by xuzepei on 8/21/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPasswordView.h"

@interface RCPasswordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)NSMutableArray* itemArray;

@end
