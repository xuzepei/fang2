//
//  RCTuanGouCell.h
//  RCFang
//
//  Created by xuzepei on 6/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTuanGouCellContentView.h"

@interface RCTuanGouCell : UITableViewCell

@property(nonatomic,retain)RCTuanGouCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
