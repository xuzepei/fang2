//
//  RCZiXunCell.h
//  RCFang
//
//  Created by xuzepei on 4/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCZiXunCellContentView.h"

@interface RCZiXunCell : UITableViewCell

@property(nonatomic,retain)RCZiXunCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
