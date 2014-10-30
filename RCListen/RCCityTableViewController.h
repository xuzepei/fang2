//
//  RCCityTableViewController.h
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCityTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)NSDictionary* result;

- (void)updateContent:(NSDictionary*)item;

@end
