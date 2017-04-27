//
//  RCSecondHandHouseCell.h
//  RCFang
//
//  Created by xuzepei on 3/26/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSecondHandHouseCellContentView.h"

@interface RCSecondHandHouseCell : UITableViewCell

@property(nonatomic,retain)RCSecondHandHouseCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
