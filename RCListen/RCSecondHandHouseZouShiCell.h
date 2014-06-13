//
//  RCSecondHandHouseZouShiCell.h
//  RCFang
//
//  Created by xuzepei on 4/22/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSecondHandHouseZouShiContentView.h"

@interface RCSecondHandHouseZouShiCell : UITableViewCell

@property(nonatomic,retain)RCSecondHandHouseZouShiContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
